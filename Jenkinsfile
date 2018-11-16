pipeline{
    agent{
        node{
            label 'DesignerWin'
            customWorkspace 'C:/CloudTransformation/SAGLiveWorkspace'
            }
        }
    stages{
        stage{
            parallel{
                    stage('CheckOut Assets'){
                        steps{
                            sh 'git clone --recursive https://github.com/AbhishekGupta1506/CloudSAGLiveAssets.git'
                            }
                    }
                    stage('CheckOut Config'){
                        steps{
                            sh 'git clone --recursive https://github.com/AbhishekGupta1506/CloudSAGLiveConfig.git'
                        }
                    }
                }
        }        
    }
}