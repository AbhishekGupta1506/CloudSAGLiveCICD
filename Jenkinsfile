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
        stage('CheckOut'){
            parallel{
                stage('checkout GITAssets'){
                    steps{
                        script{
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
                stage('checkout Cloud AssetsBuild'){
                    steps{
                        script{
                            if (!fileExists('CloudAssetsBuild')) { 
                                bat 'mkdir CloudAssetsBuild'
                            } 
                            else{
                                dir('C:/CloudTransformation/SAGLiveWorkspace/CloudAssetsBuild'){
                                   // bat 'del /s /q *'
                                   echo "delete all cloud assets"
                                   bat 'dir'
                                }
                            }
                            dir('C:/CloudTransformation/SAGLiveWorkspace/CloudAssetsBuild'){
                                bat 'git config --global http.sslVerify false'
                                bat 'git config --global credential.helper cache'
                                bat 'git config --global push.default simple'
                                checkout([ $class: 'GitSCM', branches: [[name: '*/master']], extensions: [ [$class: 'CloneOption', noTags: true, reference: '', shallow: true] ], submoduleCfg: [], userRemoteConfigs: [[ credentialsId: 'cloudUsernamePassword', url: 'https://miqsagcloud.saglive.com/integration/rest/internal/wmic-git/stage00-soln-is']]])
                            }             
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
                   dir('C:/CloudTransformation/SAGLiveWorkspace/CloudAssetsBuild'){
                      bat 'git status'
                      bat 'git remote show origin'
                      bat 'git add .'
                      bat 'git commit -am "pushing the latest build"'  
                      bat 'git push'  
                   }
               }
            }
        }     
    }
}