import QtQuick 2.0

/***
Файл root_object.qml. Используется при создании надписи для корневого объекта программы.
***/
Text {
    id: root
    text: qsTr("корень")
    color: "#0000FF"


    MouseArea {
        anchors.fill: parent
        drag.target: parent
        drag.axis: Drag.XYAxis

        }
}
