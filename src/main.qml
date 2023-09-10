/*
 * Copyright (C) 2020 Chandler Swift <chandler@chandlerswift.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.9
import org.asteroid.controls 1.0
import Qt.labs.folderlistmodel 2.1

Application {
    id: app

    property var inEditMode: false

    centerColor: folderModel.count > 0 ? "#000" : "#31bee7"
    outerColor:  folderModel.count > 0 ? "#000" : "#052442"

    FolderListModel {
        id: folderModel
        folder: "file:///home/ceres/Pictures"
        nameFilters: ["*.jpg", "*.png", "*.gif"]
        sortField: FolderListModel.Time
        sortReversed: false
        showDirs: false
    }

    StatusPage {
        text: "No photos found"
        icon: "ios-images"
        visible: !inEditMode && folderModel.count === 0
    }

    function edit(imagePath) {
        inEditMode = true
        imageToEdit.source = imagePath
    }

    Item {
        anchors.fill: parent

        visible: !inEditMode && folderModel.count > 0

        Component {
            id: photoDelegate
            Item {
                width: app.width
                height: app.height

                Image {
                    source: fileURL
                    width: app.width
                    height: app.height
                    fillMode: Image.PreserveAspectFit
                }

                Label {
                    text: fileName
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: Dims.h(33)
                    font.pixelSize: Dims.l(6)
                    font.bold: true
                }
                Rectangle {
                    color: "transparent"
                    width: 60
                    height: 60
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                        bottomMargin: parent.height * 0.05
                    }
                    IconButton {
                        iconName: "ios-brush-outline"
                        anchors.fill: parent
                        onClicked: edit(fileURL)
                    }
                }
            }

        }

        ListView {
            id: lv
            anchors.fill: parent
            model: folderModel
            delegate: photoDelegate
            orientation: ListView.Horizontal
            snapMode: ListView.SnapToItem
            highlightRangeMode: ListView.StrictlyEnforceRange
            onCurrentIndexChanged: inEditMode = false
        }

        // Currently PageDot is not used because it tends the currently shown indication
        // tends to be displayed off the screen with larger numbers of images.
        // Potentially, we can rework PageDot to display the current dot centered, and
        // move other dots around it.
        //        PageDot {
        //            height: Dims.h(3)
        //            anchors.horizontalCenter: parent.horizontalCenter
        //            anchors.top: parent.top
        //            anchors.topMargin: Dims.h(3)
        //            currentIndex: lv.currentIndex
        //            dotNumber: folderModel.count
        //        }
    }

    Item {
        // TODO: add to LayerStack

        anchors.fill: parent
        visible: inEditMode

        Image {
            id: imageToEdit
            source: "" // filled when we click the edit button
            width: app.width
            height: app.height
            fillMode: Image.PreserveAspectFit
            transform: Rotation { // This is just here as a UI demo; it won't actually edit an image.
                id: imageToEditRotation
                angle: 0
                origin.x: imageToEdit.width/2
                origin.y: imageToEdit.height/2
            }
        }

        IconButton {
            id: savebtn
            iconName: "ios-checkmark-circle-outline"
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: parent.height * 0.05
            }
            onClicked: inEditMode = false
        }

        IconButton {
            id: rotateleftbtn
            iconName: "ios-refresh-circle-outline"
            transform: Scale { xScale: -1 }
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: parent.height * 0.05 + width
            }
            onClicked: imageToEditRotation.angle -= 90
        }

        IconButton {
            id: rotaterightbtn
            iconName: "ios-refresh-circle-outline"
            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: parent.height * 0.05
            }
            onClicked: imageToEditRotation.angle += 90
        }

    }
}
