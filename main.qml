/*
 * Copyright (C) 2019 Florent Revest <revestflo@gmail.com>
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

    centerColor: "#31bee7"
    outerColor: "#052442"

    FolderListModel {
        id: folderModel
        folder: "file:///home/ceres/Pictures"
        nameFilters: ["*.jpg"]
        sortField: FolderListModel.Time
        sortReversed: false
        showDirs: false
    }

    StatusPage {
        text: "No pictures to display"
        icon: "ios-images"
        visible: false // TODO
    }

    Item {
        anchors.fill: parent

        visible: true // TODO

        Component {
            id: photoDelegate
            Item {
                width: app.width; height: app.height

                Image {
                    source: fileURL
                    width: app.width; height: app.height
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
            }
        }

        ListView {
            id: lv
            anchors.fill:parent
            model: folderModel
            delegate: photoDelegate
            orientation: ListView.Horizontal
            snapMode: ListView.SnapOneItem
            highlightRangeMode: ListView.StrictlyEnforceRange
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


}
