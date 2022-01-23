import QtQuick 2.0

/***
Это файл Cell.qml. Он описывает созданные элементы Rectangle, которые в программе представляют клетки памяти.
***/
Rectangle {
    id: cell
    width: 100; height: 90; radius: 180;
    property string cell_color: "#F5F5DC"
    property int val: 0
    property int clean: appWindow.clean
    color: cell_color
    onCleanChanged: remove_garbage()
    function remove_garbage(){
        appWindow.requestUpdate()
        if(cell_color==="#F5F5DC"){
            garbage_image.visible = true

        }
    }


    MouseArea {
        anchors.fill: parent
        drag.target: parent
        drag.axis: Drag.XYAxis
        onClicked: cell.cell_color = (cell.cell_color === "#F5F5DC" ? "light blue" : "#F5F5DC" )
    }


    Image {
        id: garbage_image
        source: "garbage.png"
        width: 50; height: 40
        anchors.centerIn: parent
        visible: false
    }


    Text {
        id: value
        color: "black"
        anchors.centerIn: parent
        text: String.fromCharCode(cell.val)
        onTextChanged: console.log(value)


        MouseArea {
            anchors.fill: parent
            function createObjectsLabels(){
                var component = Qt.createComponent("Cell_label.qml");
                var cell_label = component.createObject(appWindow, {text: value.text,});

                if(cell_label === null){

                    console.log("Error creating cell label");
                }
            }
            onClicked: createObjectsLabels()

        }
    }
 }
