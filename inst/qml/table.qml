//
// Copyright (C) 2013-2018 University of Amsterdam
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.
//
import QtQuick			2.8
import QtQuick.Layouts	1.3
import JASP.Controls	1.0
import JASP.Widgets		1.0
import JASP				1.0

Form
{

  Text
  {
      text: "Add your times and positions below"
  }

  VariablesForm
  {
    AvailableVariablesList { name: "allVariables" }
    AssignedVariablesList  { name: "t"; label: qsTr("Times (t)"); singleVariable: true; allowedColumns: ["scale"] }
    AssignedVariablesList  { name: "x"; label: qsTr("Horizontal positions (x)"); singleVariable: true; allowedColumns: ["scale"] }
    AssignedVariablesList  { name: "y"; label: qsTr("Vertical positions (y)"); singleVariable: true; allowedColumns: ["scale"] }
  }

  Text{text: "Append the desired dynamical variables"}

  CheckBox 
  { 
    name: "doSpeeds"
    label: qsTr("Speeds")
    checked: true
    columns: 2
    CheckBox { name: "speedsAsVectors"; label: qsTr("Directional speed") ; checked: true }
    CheckBox { name: "speedsAsScalars"; label: qsTr("Absolute speed") ; checked: false }
  }

  CheckBox 
  { 
    name: "doAccels"
    label: qsTr("Accelerations")
    checked: false 
    columns: 2
    CheckBox { name: "accelsAsVectors"; label: qsTr("Directional acceleration") ; checked: true }
    CheckBox { name: "accelsAsScalars"; label: qsTr("Absolute acceleration") ; checked: false }
  }

  CheckBox 
  {
    name: "doCurvatures"
    label: qsTr("Curvatures")
    checked: false
    columns: 2
    CheckBox { name: "asCurvature"; label: qsTr("As curvature")           ; checked: true }
    CheckBox { name: "asRadius";	  label: qsTr("As curvature radius") ; checked: false }
  }

	IntegerField
	{
		name: "sf"
		label: qsTr("Significant figures")

		min: 1
		defaultValue: 3
	}

}
