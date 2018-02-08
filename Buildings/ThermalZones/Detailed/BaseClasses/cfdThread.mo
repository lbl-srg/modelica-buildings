within Buildings.ThermalZones.Detailed.BaseClasses;
class CFDThread "create constructor and destructor associated with external objects"
	extends ExternalObject;
	// constructor 
	function constructor "create ffd.dll or ffd.so"
		input String cfdFilNam "CFD input file name";
		input String[nSur] name "Surface names";
		input Modelica.SIunits.Area[nSur] A "Surface areas";
		input Modelica.SIunits.Angle[nSur] til "Surface tilt";
		input Buildings.ThermalZones.Detailed.Types.CFDBoundaryConditions[nSur] bouCon
			"Type of boundary condition";
		input Integer nPorts(min=0)
			"Number of fluid ports for the HVAC inlet and outlets";
		input String portName[nPorts]
			"Names of fluid ports as declared in the CFD input file";
		input Boolean haveSensor "Flag, true if the model has at least one sensor";
		input String sensorName[nSen]
			"Names of sensors as declared in the CFD input file";
		input Boolean haveShade "Flag, true if the windows have a shade";
		input Integer nSur "Number of surfaces";
		input Integer nSen(min=0)
			"Number of sensors that are connected to CFD output";
		input Integer nConExtWin(min=0) "number of exterior construction with window";
		input Integer nXi(min=0) "Number of independent species";
		input Integer nC(min=0) "Number of trace substances";
		input Modelica.SIunits.Density rho_start "Density at initial state";
		output Integer retVal
			"Return value of the function (0 indicates CFD successfully started.)";
		// FIXME: need to declare a struct FFDThread as void pointer
		output CFDThread FFDThre "the handler of FFD thread";
		// FIXME: need to let cfdStartCosimulation return a construct
		external"C" FFDThre = cfdStartCosimulation(
			cfdFilNam,
			name,
			A,
			til,
			bouCon,
			nPorts,
			portName,
			haveSensor,
			sensorName,
			haveShade,
			nSur,
			nSen,
			nConExtWin,
			nXi,
			nC,
			rho_start) annotation (Include="#include <cfdStartCosimulation.c>",
				IncludeDirectory="modelica://Buildings/Resources/C-Sources",
				LibraryDirectory="modelica://Buildings/Resources/Library", Library="ffd");	
	end constructor;
	
	// destructor
	// FIXME: implement a new function to send stop command, wait for FFD to send its status, and close thread
	function destructor "release ffd.dll or ffd.so"
		input FFDThread PoinFFDThre "the handler of FFD thread";
		external"C" retVal = cfdCloseThread(FFDThre)annotation (Include="#include <cfdStartCosimulation.c>",
				IncludeDirectory="modelica://Buildings/Resources/C-Sources",
				LibraryDirectory="modelica://Buildings/Resources/Library", Library="ffd");	
	end destructor;


end cfdThread;