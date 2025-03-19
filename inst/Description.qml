import QtQuick		2.12
import JASP.Module	1.0

Description
{
	name		: "jaspKinematics"
	title		: qsTr("Kinematics")
	description	: qsTr("Movement analysis with JASP")
	version		: "0.1"
	author		: "JASP Team"
	maintainer	: "JASP Team <info@jasp-stats.org>"
	website		: "https://jasp-stats.org"
	license		: "GPL (>= 2)"
	icon        : "icon.svg" // Located in /inst/icons/
	preloadData: true
	requiresData: true


	GroupTitle
	{
		title:	qsTr("Basic functions")
	}

	Analysis
	{
	  title: "Extract kinematic variables"
	  menu: "Extract kinematic variables"
	  func: "ProcessTable"
	  qml: "table.qml"
	}
}