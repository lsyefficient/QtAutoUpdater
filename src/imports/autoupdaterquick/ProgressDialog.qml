import QtQuick 2.13
import QtQuick.Layouts 1.13
import QtQuick.Controls 2.13
import de.skycoder42.QtAutoUpdater.Core 3.0

DialogBase {
	id: progressDialog

	title: qsTr("Checking for updates…")

	visible: false

	ProgressItem {
		id: progressItem
		anchors.fill: parent

		// assign states here, as Dialg has no states...
		states: [
			State {
				name: "inactive"
				PropertyChanges {
					target: btnBox.standardButton(DialogButtonBox.Cancel)
					enabled: false
				}
				PropertyChanges {
					target: progressItem
					progress: -1.0
					status: ""
				}
			},
			State {
				name: "checking"
				PropertyChanges {
					target: progressDialog
					visible: updater
				}
				PropertyChanges {
					target: btnBox.standardButton(DialogButtonBox.Cancel)
					enabled: true
				}
			},
			State {
				name: "canceling"
				PropertyChanges {
					target: progressDialog
					visible: updater
				}
				PropertyChanges {
					target: btnBox.standardButton(DialogButtonBox.Cancel)
					enabled: false
				}
				PropertyChanges {
					target: progressItem
					status: qsTr("Canceling…")
				}
			}
		]
		state: {
			switch (updater ? updater.state : Updater.Error) {
			case Updater.Checking:
				return "checking";
			case Updater.Canceling:
				return "canceling";
			default:
				return "inactive";
			}
		}

		Connections {
			target: updater

			onProgressChanged: {
				progressItem.progress = progress;
				if (updater.state == Updater.Checking)
					progressItem.status = status;
			}
		}
	}

	footer: Item {
		implicitWidth: btnBox.implicitWidth
		implicitHeight: btnBox.implicitHeight

		DialogButtonBox {
			id: btnBox
			anchors.fill: parent

			standardButtons: DialogButtonBox.Cancel

			onClicked: {
				if (button === standardButton(DialogButtonBox.Cancel))
					updater.abortUpdateCheck();
			}
		}
	}
}
