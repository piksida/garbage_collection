import QtQuick 2.0
import QtMultimedia 5.12

/***
Это файл сell.qml. Он описывает созданные элементы Rectangle, которые в программе представляют клетки памяти.
***/
Rectangle {
    id: cell
    width: 100; height: 90;
    color: "#F5F5DC"


    /***
    Тип Image отвечает за работу с изображениями. Для корректной работы с файлом, нужно указать его источник в свойстве
    source. Также можно установить видимость картинки в свойстве visible. Значение по умолчанию - true.
    ***/
    Image {
        id: recycle_image
        source : "garbage.png"
        anchors.centerIn: parent
        width: 50; height: 45;
        visible: false
    }


    /***
    Тип Audio отвечает за работу с аудио. Для корректной работы нужно также указать его источник звуковой дорожки.
    ***/
    Audio {
        id: garbage_sound
        source: "trash_throw.wav"
        onStopped: cell.destroy()
    }


    /***
    Свойство drag.target позволяет нам захватывать выбранный объект и переносить его вдоль коорлинат, заданных в
    drag.axis.
    ***/
    MouseArea {
        anchors.fill: parent
        drag.target: parent
        drag.axis: Drag.XYAxis
        onClicked: reference_count.increment()
    }


    Text {
        id: reference_count
        color: "black"
        anchors.centerIn: parent
        property int value: 0
        text: value
        onTextChanged: console.log(value)
        function increment(){
            value = value + 1
        }
        function decrement(){
            if (value === 0) {
                return;
            }

            value = (value - 1)

            if (value === 0) {
                reference_count.visible = false
                recycle_image.visible = true
                garbage_color.running = true

            }
        }
    }


    /***
    Тип Animation позволяет сделать интерфейс программы более приятным для пользоветеля, с помощью создания
    последовательного показа файлов.
    ***/
    ColorAnimation on color {
        id: garbage_color
        to: "light grey"
        duration: 8000
        property bool run: false
        running: false
        alwaysRunToEnd: true
        onStopped: {
            garbage_sound.play()

        }
    }


    Rectangle {
        id: plus_rec
        width: 25; height: 15;
        anchors.right: parent.right
        color: "light blue"


        Text {
            id: plus
            color: "black"
            anchors.centerIn: parent
            text: "+"
        }


        MouseArea {
            anchors.fill: parent
            onClicked: reference_count.increment()
        }
    }


    Rectangle {
        id: minus_rec
        width: 25; height: 15;
        anchors.left: parent.left
        color: "light blue"


        Text {
            id: minus
            color: "black"
            anchors.centerIn: parent
            text: "-"
        }


        MouseArea {
            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.XYAxis
            onClicked: reference_count.decrement()
        }
    }
}
