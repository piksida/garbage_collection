import QtQuick 2.12
import QtQuick.Window 2.12

/***
Это главный файл программы. Window является корнем дерева и отвечает за отображение экрана пользователю. Каждому элементу
можно присвоить свой id. С помощью него можно образаться к элементам. Он должен быть уникальным для исключения неоднознач-
ности. Были заданы парметры размеров, цвета и загаловка окна, на мой взгляд, наиболее благоприятные для пользователя.
***/
Window {
    id: appWindow
    width: 640
    height: 480
    visible: true
    color: "azure"
    title: qsTr("Подсчет ссылок")


    /***
    QML тип Сanvas предоставляет все необходимые инструменты для рисования прямых и кривых линий.
    Это позволит создавать в программе линии-указатели на объекты. Свойство anchors.fill указывает
    область использования типа. В нашем случае это элемент родитель типа, то есть наше окно. Таким
    образом функция рисования распростроняется на все окно. Также были заданы свойства координат,
    цет линии и ее ширина. Свойство onPaint описывает действия, которые будут происходить при пос-
    туплении сигнала о рисовании. Далее мы создаем объкт ctx типа Context2D, с помощью которого
    мы зададим необходимые свойства для рисования.
    ***/
    Canvas {
            id: canvas
            anchors.fill: parent
            property int lastX: 0
            property int lastY: 0
            property string color: "azure"
            property int lineWidth: 2

            onPaint: {
                var ctx = getContext("2d");
                ctx.lineWidth = lineWidth;
                ctx.strokeStyle = color;

                ctx.beginPath();

                ctx.moveTo(lastX, lastY);

                lastX = paint_area.mouseX
                lastY = paint_area.mouseY

                ctx.lineTo(lastX, lastY);
                ctx.stroke();

            }


            /***
            QML тип MouseArea позволяет нам обрабатывать нажатия компьютерной мышки.
            В случае ниже при нажатии будут заданы начальные координаты для рисования.
            соответсвующие положению курсора мыши. При изменении положения будет подан
            сигнал на рисование.
            ***/
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


    /***
    QML тип Row дает возможность создать последовательность элементов с заданным промежутком
    между ними. Промежуток задается в свойстве spacing. Я создала три элемента типа Text, который ис-
    пользуется для отображения надписей на экране. Названия надписям были выбраны в контексте их функционала.
    При нажатии на надписи будут реализованы инструкции: createRootObjects, createCellObjects, modifyLineWidth,
    setDrawingMode. CreateRootObjects и createCellObjects создают новые объекты в окне, описанные в сторонних qml
    файлах. Для удобства отладки, в случае неудачного создания объектов в консоль будет выводиться соответствующее
    сообщение. modifyLineWidth и setDrawingMode описывают логику взаимодействия нажатия на кнопки-надписи и рисования.
    ***/
    Row
    {
        spacing: 10


        Text {
            id: root
            text: qsTr("корень")
            color: "#0000FF"


            MouseArea {
                anchors.fill: parent
                onClicked: createRootObjects()
                function createRootObjects(){
                    var component = Qt.createComponent("root_object.qml");
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
                    var component = Qt.createComponent("cell.qml");
                    var cell = component.createObject(appWindow);

                    if(cell === null){

                        console.log("Error creating cell");
                    }
                }
                onClicked: createCellObjects()
            }
        }


            Text {
                id: draw_button
                text: qsTr("рисовать")
                property string color_var: "#0000FF"
                color: color_var
                onColorChanged: modify_lineWidth()
                function modify_lineWidth(){
                    if (canvas.color==="azure"){
                        canvas.lineWidth = canvas.lineWidth * 4
                    }

                    else{
                        canvas.lineWidth = 2
                    }
                }


                MouseArea {
                    anchors.fill: parent
                    onClicked: setDrawingMode()
                    function setDrawingMode(){
                        canvas.color = (canvas.color==="azure" ? "dark blue" : "azure")
                        draw_button.color_var = (draw_button.color_var==="#0000FF" ? "red" : "#0000FF")

                    }
                }
            }
    }
}
