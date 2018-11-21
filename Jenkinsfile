def assetsBuildPresent = false
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
                stage('checkout Assets'){
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
               // stage('checkout AssetsBuild'){
                   // parallel{
                        /**stage('checkout GIT AssetsBUild'){
                            steps{
                                script{
                                    if (!fileExists('AssetsBuild')) {  
                                        bat 'mkdir AssetsBuild'
                                        dir('C:/CloudTransformation/SAGLiveWorkspace/AssetsBuild'){ 
                                            echo 'cloning the project'                              
                                            bat 'git clone https://github.com/AbhishekGupta1506/CloudSAGLiveAssetBuildUsingABE.git'
                                    }
                                    } else {
                                        echo 'AssetsBuild directory exist'
                                        dir('C:/CloudTransformation/SAGLiveWorkspace/AssetsBuild/CloudSAGLiveAssetBuildUsingABE'){                            
                                            echo 'pulling the updates'                              
                                            bat 'git pull'
                                        }
                                    }                   
                                }                                                        
                             }
                        }**/
                        stage('checkout Cloud AssetsBuild'){
                            steps{
                                script{
                                    bat 'git config --global http.sslVerify false'
                                    bat 'git config --global credential.helper cache'
                                    bat 'git config --global push.default simple'
                                    checkout([
                                                $class: 'GitSCM',
                                                branches: [[name: master]],
                                                extensions: [
                                                    [$class: 'CloneOption', noTags: true, reference: '', shallow: true]
                                                ],
                                                submoduleCfg: [],
                                                userRemoteConfigs: [
                                                    [ credentialsId: 'cloudUsernamePassword', url: 'https://miqsagcloud.saglive.com/integration/rest/internal/wmic-git/stage00-soln-is']
                                                ]
                                            ])
                                    if (!fileExists('CloudAssetsBuild')) {  
                                        bat 'mkdir CloudAssetsBuild'
                                        dir('C:/CloudTransformation/SAGLiveWorkspace/CloudAssetsBuild'){ 
                                            echo 'cloning the project'                              
                                            bat "git checkout master" //To get a local branch tracking remote
                                    }
                                    } else {
                                        echo 'AssetsBuild directory exist'
                                        dir('C:/CloudTransformation/SAGLiveWorkspace/CloudAssetsBuild/stage00-soln-is'){                            
                                            echo 'pulling the updates'                              
                                            bat 'git pull'
                                        }
                                    }                   
                                }                                                        
                             }
                        }
                   // }
                 //}
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
            //update this step to deploy to Clour LAR/GIT once it is stable
            steps{
                sshagent(credentials : ['AccessGitFromvmsiqacloud02']){
                    dir('C:/CloudTransformation/SAGLiveWorkspace/AssetsBuild/CloudSAGLiveAssetBuildUsingABE'){
                       /** bat 'git config --global user.name AbhishekGupta1506'
                        bat 'git config --global user.email abhishekgupta@gmail.com'
                        //bat 'git commit --amend --reset-author -am "updated the username and email"'
                        bat 'git init'
                        bat 'git remote add origin https://github.com/AbhishekGupta1506/CloudSAGLiveAssetBuildUsingABE.git'
                        bat 'git pull origin master --allow-unrelated-histories'**/
                        bat 'git status'
                        bat 'git add .'
                        bat 'git commit -am "pushing assets build automatically"'
                        bat 'git push git+ssh://git@github.com/AbhishekGupta1506/CloudSAGLiveAssetBuildUsingABE.git --all | true'

                    }
                }
            }
        }     
    }
}