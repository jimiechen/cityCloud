# cityCloud
云小酱App


# 自动部署使用
* 安装fastlane ：通过`gem install fastlane`或者`brew install fastlane`命令在电脑中安装
* 打包并上传apk到蒲公英：执行`flutter build appbundle`，然后项目下的android目录下执行`fastlane forPgyer`命令就会自动打包apk并上传蒲公英。
  
  设置安装密码或者描述，可以修改android目录下fastlane/Fastfile中pgyer命令的参数，如改为`pgyer(api_key: "4198f2f3876788e3a4dc1c73ef0cbc5c", user_key: "8e5911e4f450b2c4924454f4af3f438c", apk:"../build/app/outputs/flutter-apk/app-release.apk",password: "123",update_description: "版本更新描述")`则安装密码是123.
* 打包不上传apk：项目下的android目录下执行`fastlane beta`命令。生成的apk处于项目目录下的`build/app/outputs/flutter-apk/app-release.apk`路径
* iOS暂无，原理类似