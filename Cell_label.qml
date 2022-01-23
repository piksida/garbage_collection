import QtQuick 2.0

/***
Файл Сell_label.qml. Описывает надписи на объектах-клетках в программе.
***/
Text {
    id: cell_label
    color: "black"
    x: 330; y: 770


    MouseArea {
        anchors.fill: parent
        drag.target: parent
        drag.axis: Drag.XYAxis

        }
}
