import QtQuick 2.12
import QtQuick.Window 2.12

/***
Главный файл Mark_sweep.qml.
***/
Window {
    id: appWindow
    width: 640
    height: 480
    visible: true
    property int cell_value: 97
    property int clean: 0
    title: qsTr("Алгоритм пометок")


    Image {
        id: head
        source : "arrow.jpg"
        x: 335; y: 775
        width: 50; height: 160;
    }


    Image {
        id: tail
        source : "arrow.jpg"
        x: 335; y: 775
        width: 50; height: 160;

    }


    Canvas {
            id: canvas
            anchors.fill: parent
            property int lastX: 0
            property int lastY: 0
            property string color: "white"

            onPaint: {
                var ctx = getContext("2d");
                ctx.lineWidth = 2;
                ctx.strokeStyle = color;

                ctx.beginPath();

                ctx.moveTo(lastX, lastY);

                lastX = paint_area.mouseX
                lastY = paint_area.mouseY

                ctx.lineTo(lastX, lastY);
                ctx.stroke();
                ctx.save();

            }


            MouseArea {
                id: paint_area
                anchors.fill: parent
                onPressed: {
                    canvas.lastX = mouseX
                    canvas.lastY = mouseY
                }
                onPositionChanged: {
                    canvas.requestPaint()
                }
            }
        }


    Row{
        spacing: 10

        Text {
            id: root
            text: qsTr("корень")
            color: "#0000FF"

            MouseArea {
                anchors.fill: parent
                onClicked: createRootObjects()
                function createRootObjects(){
                    var component = Qt.createComponent("Root_object.qml");
                    var cell = component.createObject(appWindow);

                    if(cell === null){

                        console.log("Error creating cell");
                    }
                }
            }
        }


        Text {
            id: cell_button
            text: qsTr("объект")
            color: "#0000FF"


            MouseArea {
                anchors.fill: parent
                function createCellObjects(){
                    var component = Qt.createComponent("Cell.qml");
                    var cell = component.createObject(appWindow, {val: appWindow.cell_value});

                    if(cell === null){

                        console.log("Error creating cell");
                    }
                    appWindow.cell_value = appWindow.cell_value + 1
                }
                onClicked: createCellObjects()
            }
        }


            Text {
                id: draw_button
                text: qsTr("рисовать")
                property string color_var: "#0000FF"
                color: color_var


                MouseArea {
                    anchors.fill: parent
                    onClicked: setDrawingMode()
                    function setDrawingMode(){
                        canvas.color = (canvas.color==="white" ? "dark blue" : "white")
                        draw_button.color_var = (draw_button.color_var==="#0000FF" ? "red" : "#0000FF")

                    }
                }
        }


            Rectangle{
                width: 60; height: 30
                color: "green"


                Text {
                    text: qsTr("готово")
                    anchors.centerIn: parent
                    color: "white"
                }


                MouseArea {
                    anchors.fill: parent
                    onClicked: appWindow.clean = 1

                }
            }
    }


    Row{
        id: slots
        x: 350; y: 700

        /***
        Тип Repeater позволяет нам создать множество однотипных объектов. Количество объектов
        задается в свойстве model. Это сокращает объем кода.
        ***/
        Repeater{
            model:12
            Rectangle {
                width: 100; height:90
                border.width: 1
                property string cell_color: "beige"
                color: cell_color


                MouseArea {
                    anchors.fill: parent
                    onClicked: move_pointer()
                    function move_pointer(){
                        if (parent.cell_color==="green"){
                            return;
                        }

                        parent.cell_color = (parent.cell_color === "beige"? "light blue" : "green")
                        var new_color = parent.cell_color

                        if(parent.cell_color=="light blue"){
                            tail.x = tail.x + 100
                        }

                        else{
                            if(head.x===335){
                            head.x = 395
                            }

                            else{
                                head.x = head.x + 100
                            }

                        }
                    }
                }
            }
        }
    }
}
