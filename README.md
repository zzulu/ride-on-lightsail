# Ride on Lightsail

## 0. AWS 가입

[Amazon Web Services](https://aws.amazon.com/ko/)에 접속하여 회원 가입을 한다.
- 회원 가입을 할 때, 해외 결제가 되는 카드가 필요하다.
- 카드 등록 시 결제되는 1달러는 카드가 유효한지 검사하는 가결제이므로 곧 환불 처리 된다.

## 1. 사용할 프로젝트 선택

- 본인의 GitHub에 프로젝트 Repository가 있어야 한다.
- Github에 개인 프로젝트가 없는 사람은 본인의 프로젝트를 업로드하도록 하자.

## 2. Lightsail

### 2.1. Lightsail 생성

Lightsail을 검색하거나 '컴퓨팅' 항목에서 Lightsail을 찾는다.

![Find Lightsail](/images/001.png)

Lightsail 인스턴스를 생성한다.

![Create Instance](/images/002.png)

설정은 다음과 같이 한다.

![Instance Configure](/images/003-1.png)
![Instance Configure](/images/003-2.png)

- 인스턴스 위치가 `서울, 영역 A (ap-northeast-2a)`로 되어 있는지 확인한다. 아니라면 `리전 및 영역 변경`을 통하여 설정한다.
- 인스턴스 이미즈는 `Linux/Unix` > `OS 전용` > `Ubuntu`로 지정한다.
- 다른 항목은 그대로 두고 아래쪽의 **생성** 버튼을 클릭한다.

다음과 같이 **대기중**으로 표시되었다가, **실행 중**으로 변경되면 인스턴스가 생성이 완료된 것이다.
![Instance Pending](/images/004-1.png)
![Instance Created](/images/004-2.png)

생성된 인스턴스의 우측 상단에 터미널(console) 모양의 아이콘을 클릭하면, 생성한 인스턴스에 접속(ssh)할 수 있다.

### 2.2. 주의사항

- 인스턴스를 생성한 순간부터 과금이 될 수 있다. 과금 유의사항을 항상 자세히 읽어보기를 권장하며, 사용하지 않을 인스턴스는 바로 삭제를 해주는 것이 좋다.

### 2.3. 본격 Deploy

### 2.3.1. 프로젝트 가져오기

`1. 사용할 프로젝트 선택`에서 선택한 프로젝트를 Lightsail Instance로 가져온다. 여기서는 [zzulu](https://github.com/zzulu)의 [insta-jeju](https://github.com/zzulu/insta-jeju)를 가져오지만 각자 개인의 프로젝트를 가져오도록 한다.

```console
$ cd ~
$ git clone https://github.com/zzulu/insta-jeju
``` 

프로젝트를 가져온 후, 개발을 하면서 사용하였던 `master.key` 파일의 내용을 복사하여 `master.key` 파일을 config 폴더 안에 생성하고 붙여넣는다.

#### 2.3.2. Auto Server Setup Script 가져오기

`git clone` 명령어로 Auto Server Setup Script를 가져온다. 지금 보고 있는 이 문서의 repository에 포함되어 있다.

```console
$ cd ~
$ git clone https://github.com/zzulu/ride-on-lightsail.git
```

실행에 앞서 편의를 위하여 현재 폴더를 변경하자.

```console
$ cd ~/ride-on-lightsail
```

#### 2.3.2. 1_rbenv.sh 실행

서버 설정을 매우 편리하게 해주기 위하여 script를 작성하였다. 아까 받은 Script를 실행하면 모든 설정이 자동으로 될 것이다. `sh` 명령어를 사용하여 실행해보자. 우선 `1_rbenv.sh` 먼저.

```console
$ sh ./scripts/1_rbenv.sh
```

#### 2.3.3. shell 새로고침

`1_rbenv.sh`에서 많은 것들을 설치하였는데, 그것들을 사용하기 위하여 shell을 refresh 해주자. 가끔 프로그램을 설치하고 컴퓨터를 재부팅 해주는 것과 같은 이유이다.

```console
$ exec $SHELL
```

### 2.3.4. 2_ruby_rails_nginx.sh 실행

`2_ruby_rails_nginx.sh`를 실행하여 나머지 부분의 설정을 계속하자.
`2_ruby_rails_nginx.sh`에는 `2.3.1. 프로젝트 가져오기`에서 가져온 프로젝트의 이름을 함께 넣어주어야 하는데 **PROJECT-FOLDER-NAME**은 `git clone`하였을때, 받아지는 github repository의 이름이다. `ls` 명령어로 확인이 가능하다.

`2_ruby_rails_nginx.sh`를 실행하기 전에, gem 설치에 필요한 프로그램들(dependencies)을 반드시 설치한 후, 스크립트를 실행한다.
기본적인 gem을 위한 프로그램들은 스크립트 안에서 미리 설치하도록 되어있지만, 사용자가 별도로 추가한 gem은 경우에 따라 추가적인 gem이나 프로그램이 필요할 수 있다. 

```console
$ sh ./scripts/2_ruby_rails_nginx.sh PROJECT-FOLDER-NAME
```

시간이 조금 걸리는데, 모든 과정을 마치면 브라우저에서 Lightsail의 Public IP로 접속을 하여 Application이 돌아가는 것을 확인 할 수 있다.

#### 2.3.5. Gem 설치 도중 error 발생 시

만약 gem 설치 도중 에러가 발생했다면, 에러를 수정한 후에 `2_ruby_rails_nginx.sh` 스크립트 파일을 다시 실행하여 남은 deploy 과정을 마무리한다.

## 3. Update Deployed Project (Server)

### 3.1. git pull

업데이트 된 Rails Application을 `git pull` 명령어로 내려받는다. 내려받을 때는 해당 Project folder로 들어간 후, `git pull` 명령어를 입력해준다.

```console
$ cd ~/PROJECT-FOLDER-NAME
$ git pull
```

### 3.2. Bundle Install & Asset Precompile & Restart Rails Application

Gemfile이 변경되었다면 `bundle install`로 추가된 gem들을 설치해준다. production 환경에서는 asset pipeline이 성능 향상을 위하여 사용될 assets들을 정리해서 static한 파일로 만들고, 그 파일들을 불러온다. 그 작업을 하는 명령어를 입력한다. 마지막으로 rails application을 restart 해주면 변경사항이 적용된 사이트를 확인 할 수 있다.

```console
$ bundle install
$ bundle exec rake assets:precompile RAILS_ENV=production
$ touch tmp/restart.txt
```
