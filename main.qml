import QtQuick 2.2

Rectangle {
    id:screen//main screen
    height: 800
    width: 800
    color: "white"

    Component{
        id:smallrect           //used to recognize direction
        Rectangle{
            id:rect
            height:50
            width:50
        }
    }

    Flickable{
        id:view        //our camera
        anchors.fill: parent
        contentHeight: background.height
        contentWidth: background.width
        contentX: background.width/2             //the solution of chase view
        contentY: background.height/2
        interactive:false

        Behavior on contentX{
            NumberAnimation{
                id:nax
                duration: 800            //view speed
                easing.type: Easing.Linear
            }
        }

        Behavior on contentY{
            NumberAnimation{
                id:nay
                duration: 800
                easing.type: Easing.Linear

            }
        }


        Rectangle{
            id:background
            height: 10000
            width: 10000
            color: "green"
            Component.onCompleted: {
                for(var j=0;j<1000;j++)
                    smallrect.createObject(background,{"color":Qt.rgba(Math.random(),Math.random(),Math.random()),"x":Math.random()*background.width,"y":Math.random()*background.height})
            }
        }

        Rectangle{
            id:ball         //main character
            height:50
            width:50
            x:background.width/2
            y:background.height/2
            radius: 25
            color:"white"
            Rectangle{
                id:head
                height:3
                width:25
                color:"blue"
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }

            Behavior on x{
                NumberAnimation{
                    id:nx
                    duration: 800          //ball speed
                    easing.type: Easing.Linear
                }
            }

            Behavior on y{
                NumberAnimation{
                    id:ny
                    duration: 800
                    easing.type: Easing.Linear
                }
            }
        }

        MouseArea{
            id:mymouse            //The mouse tracker
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true
            onPressed: {
                //change direction
                var dx=mouseX-ball.x-ball.width/2
                var dy=mouseY-ball.y-ball.height/2
                if(dy>0)
                    ball.rotation=Math.acos(dx/Math.sqrt(dx*dx+dy*dy))*57.3
                else
                    ball.rotation=-Math.acos(dx/Math.sqrt(dx*dx+dy*dy))*57.3
            }

            onPositionChanged: {
                if(pressed){
                    var dx=mouseX-ball.x-25
                    var dy=mouseY-ball.y-25

                    if(dy>0)
                        ball.rotation=Math.acos(dx/Math.sqrt(dx*dx+dy*dy))*57.3
                    else
                        ball.rotation=-Math.acos(dx/Math.sqrt(dx*dx+dy*dy))*57.3
                }

                //save the mouse position
                clicktimer.mouse=mapToItem(screen,mymouse.mouseX,mymouse.mouseY)
                mouse.accepted = false
            }
        }

        Timer{
            id:clicktimer
            repeat: true
            interval: 150
            running: true
            property point mouse         //the mouse position of the screen
            property double round: 0     //Smooth the view,make the view move when all stop
            onTriggered: {
                var mouseX=mymouse.mouseX       //the mouse position of the background
                var mouseY=mymouse.mouseY

                if(mymouse.pressed){
                    //change ball speed according to the mouse position
                    nx.duration=(Math.abs(mouseX-ball.x)+Math.abs(mouseY-ball.y))*3
                    ny.duration=(Math.abs(mouseX-ball.x)+Math.abs(mouseY-ball.y))*3
                    if(nx.duration<200)
                        nx.duration=200
                    if(ny.duration<200)
                        ny.duration=200

                    //change ball position according to the mouse position
                    ball.x=mapToItem(background,mouse.x,mouse.y).x
                    ball.y=mapToItem(background,mouse.x,mouse.y).y
                }

                //change view
                var dx1=mapToItem(screen,mouseX,mouseY).x-mapToItem(screen,ball.x,ball.y).x
                var dy1=mapToItem(screen,mouseX,mouseY).y-mapToItem(screen,ball.x,ball.y).y

                view.contentX=ball.x-screen.width/2+dx1/2+Math.cos(round)*50
                view.contentY=ball.y-screen.height/2+dy1/2+Math.sin(round)*50

                round+=Math.PI/36
                if(round>=2*Math.PI)
                    round=0
            }
        }
    }
}
