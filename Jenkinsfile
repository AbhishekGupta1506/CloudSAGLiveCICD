pipeline{
    agent{
        node{
            label 'DesignerWin'
            customWorkspace 'C:/CloudTransformation/SAGLiveWorkspace'
            }
        }
    environment {
        userHome="C: + %homepath%"
    }
    stages{
            stage('checkout GITAssets'){
                steps{
                    script{

                        echo 'checkout GITAssets'
                        if (!fileExists('Assets')) {
                            bat 'mkdir Assets'
                            dir('C:/CloudTransformation/SAGLiveWorkspace/Assets'){ 
                                echo 'cloning the project'                              
                                bat 'git clone --recurse-submodules https://github.com/AbhishekGupta1506/CloudSAGLiveAssets.git'
                        }
                        } else {
                            echo 'Assets directory exist'
                            dir('C:/CloudTransformation/SAGLiveWorkspace/Assets/CloudSAGLiveAssets'){                            
                                echo 'pulling the updates'                              
                                bat 'git pull'
                                bat 'git submodule update'
                            }
                        }                    
                    }                                                        
                }
            }
        stage('Install ABE'){
            steps{
                script{
                    dir('C:/CloudTransformation/SAGLiveWorkspace/script'){
                        bat 'sagabeinstall.bat'
                    }
                    
                }
            }
        }
        stage('Build'){
            steps{
                script{
                    bat 'cp C:/CloudTransformation/SAGLiveWorkspace/script/build.properties C:/SoftwareAG103ABE/common/AssetBuildEnvironment/master_build'
                    dir('C:/SoftwareAG103ABE/common/AssetBuildEnvironment/bin'){
                        bat 'build.bat'
                    }
                }
            }

        }  
        stage('Deploy'){
            //update this step to deploy to Cloud LAR/GIT once it is stable
            steps{
               echo 'deploy assets cloud LAR'
               script{
                   if (fileExists('CloudGIT')) {
                       bat 'rd /s /q CloudGIT'
                       //bat 'rd /s /q CloudGIT@tmp'
                   }
                   bat 'mkdir CloudGIT'
                   dir('C:/CloudTransformation/SAGLiveWorkspace/CloudGIT'){
                       for (int i = 1; i < 2; i++) {

                           echo 'print stage :: ${i}-${i}'
                       echo 'print stage :: stage00-Sol${i}-Sol${i}IS'
                       bat 'mkdir stage00-Sol1-Sol1IS'
                       dir('C:/CloudTransformation/SAGLiveWorkspace/CloudGIT/stage00-Sol1-Sol1IS'){
                           bat 'git config --global http.sslVerify false'
					        bat 'git config --global credential.helper cache'
					        bat 'git config --global push.default simple' 
                            checkout([ $class: 'GitSCM', branches: [[name: '*/master']], extensions: [ [$class: 'CloneOption', noTags: true, reference: '', shallow: true] ], submoduleCfg: [], userRemoteConfigs: [[ credentialsId: 'cloudUsernamePassword', url: 'https://siqa1.saglive.com/integration/rest/internal/wmic-git/stage00-Sol1-Sol1IS']]])
                              if (!fileExists('IS')) {
                                  bat 'mkdir IS'
                              }
                                echo 'copy the IS build assets'
                                dir('C:/CloudTransformation/SAGLiveWorkspace/CloudGIT/stage00-Sol1-Sol1IS/IS'){
                                    bat 'cp -r C:/CloudTransformation/SAGLiveWorkspace/CloudAssetsBuild/IS/. .'
                                }
                                if (!fileExists('CC')) {
                                    bat 'mkdir CC'
                                }
                                echo 'copy the IS build configuration'
                                dir('C:/CloudTransformation/SAGLiveWorkspace/CloudGIT/stage00-Sol1-Sol1IS/CC'){
                                    bat 'cp C:/CloudTransformation/SAGLiveWorkspace/CloudAssetsBuild/CC/localhost-OSGI-IS_default* .'	
                                } 
                              /**else{
                                  echo 'copy the UM build configuration'
                                  dir('C:/CloudTransformation/SAGLiveWorkspace/CloudGIT/stage00-Sol1-Sol1IS/CC'){
                                    bat 'cp C:/CloudTransformation/SAGLiveWorkspace/CloudAssetsBuild/CC/localhost-Universal-Messaging-umserver* .'	
                                }  
                              }          **/                                       
                            bat 'git status'
                            bat 'git remote show origin'
                            bat 'git show-ref'
                            bat 'git add .'
                            bat 'git commit -am "pushing the latest build"'  
                            bat 'git push origin HEAD:master'  
                       }
                   }

                   }
               }               
            }
        }     
    }
}