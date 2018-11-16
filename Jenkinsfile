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
        stage('CheckOut Assets'){
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
                            echo 'pulling the update'                              
                            bat 'git pull'
                            bat 'git submodule update'
                        }
                    }                    
                }                                                        
            }
        }
        stage('Build'){
            steps{
                script{
                    bat 'dir'
                    if (fileExists('AssetsBuild')) {
                        echo 'clean up the AssetsBuild folder'
                        
                        bat 'RMDIR AssetsBuild /S /q'
                    }
                    dir('C:/SoftwareAG103/common/AssetBuildEnvironment/bin'){
                        bat 'build.bat'
                    }
                }
            }

        }  
        stage('Deploy'){
            //update this step to deploy to Clour LAR/GIT once it is stable
            steps{
                sshagent(credentials : ['AbhishekJenkinsGIT']){
                    dir('C:/CloudTransformation/SAGLiveWorkspace/AssetsBuild'){
                        bat 'git init'
                        bat 'git remote add origin https://github.com/AbhishekGupta1506/CloudSAGLiveAssetBuildUsingABE.git'
                        bat 'git pull origin master --allow-unrelated-histories'
                        bat 'git add .'
                        bat 'git commit -am "pushing assets build automatically "'
                        bat 'git push git+ssh://git@github.com/AbhishekGupta1506/CloudSAGLiveAssetBuildUsingABE.git --all | true'

                    }
                }
            }
        }     
    }
}