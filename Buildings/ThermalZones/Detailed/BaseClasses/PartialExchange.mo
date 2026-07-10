within Buildings.ThermalZones.Detailed.BaseClasses;
block PartialExchange
  "Partial Block that exchanges data with the external solver"
  extends Modelica.Blocks.Interfaces.DiscreteBlock(
    firstTrigger(start=false,
                 fixed=true));
  parameter String cfdFilNam "CFD input file name" annotation (Dialog(
        loadSelector(caption=
            "Select CFD input file")));
  parameter Boolean activateInterface=true
    "Set to false to deactivate interface and use instead yFixed as output"
    annotation (Evaluate=true);
  parameter Integer nXi
    "Number of independent species concentration of the inflowing medium";
  parameter Integer nC "Number of trace substances of the inflowing medium";
  parameter Integer nWri(min=0)
    "Number of values to write to the CFD simulation";
  parameter Integer nRea(min=0)
    "Number of double values to be read from the CFD simulation";
  parameter Integer flaWri[nWri] = ones(nWri)
    "Flag for double values (0: use current value, 1: use average over interval, 2: use integral over interval)"
    annotation(Evaluate=true);
  parameter Real yFixed[nRea] "Fixed output, used if activateInterface=false"
    annotation (Dialog(enable=not activateInterface));
  parameter Integer nSur(min=2) "Number of surfaces";
  parameter Integer nConExtWin(min=0)
    "number of exterior construction with window";
  parameter CFDSurfaceIdentifier surIde[nSur] "Surface identifiers";
  parameter Boolean haveShade
    "Set to true if at least one window in the room has a shade";
  parameter Boolean haveSensor
    "Flag, true if the model has at least one sensor";
  parameter String sensorName[:]
    "Names of sensors as declared in the CFD input file";
  parameter String portName[:]
    "Names of fluid ports as declared in the CFD input file";
  parameter Boolean verbose=false "Set to true for verbose output"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.Density rho_start "Density at initial state";
  parameter Boolean haveSource
    "Flag, true if the model has at least one source";
  parameter Integer nSou(min=0)
    "Number of sources that are connected to CFD output";
  parameter String sourceName[:]
    "Names of sources as declared in the CFD input file";


  Modelica.Blocks.Interfaces.RealInput u[nWri] "Inputs to CFD"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  discrete Modelica.Blocks.Interfaces.RealOutput y[nRea] "Outputs received from CFD"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Real uInt[nWri] "Value of integral";
  discrete Real uIntPre[nWri] "Value of integral at previous sampling instance";
  discrete Real uWri[nWri] "Value to be sent to the CFD interface";

protected
  final parameter Integer nSen(min=0) = size(sensorName, 1)
    "Number of sensors that are connected to CFD output";
  final parameter Integer nPorts=size(portName, 1)
    "Number of fluid ports for the HVAC inlet and outlets";
  // Pre-computed array of surface names, extracted from the array of records
  // surIde. This avoids Dymola's internal error "failed to expand string",
  // which occurs when an array projection such as surIde.name,
  // surIde[:].name, or an array constructor such as
  // {surIde[i].name for i in 1:nSur} is used to extract a String field
  // from an array of records, either directly or as an actual argument to
  // a function call (e.g. assertStringsAreUnique, sendParameters) that is
  // evaluated during translation (e.g. in an initial algorithm section).
  // Instead, the extraction is done inside a function using an explicit
  // for loop that assigns each element individually, which Dymola can
  // expand correctly.
  final parameter String surNam[nSur] = getSurfaceNames(surIde)
    "Names of all surfaces, pre-extracted to avoid Dymola translation error";
  discrete Modelica.Units.SI.Time modTimRea(fixed=false)
    "Current model time received from CFD";

  discrete Integer retVal(start=0, fixed=true) "Return value from CFD";


  ///////////////////////////////////////////////////////////////////////////
  // Function that extracts the name field of an array of CFDSurfaceIdentifier
  // records into a String array. This is implemented as a function with an
  // explicit for loop, rather than as an array projection such as
  // surIde.name or surIde[:].name, or an array constructor such as
  // {surIde[i].name for i in 1:size(surIde,1)}, because Dymola's code
  // generator has been observed to fail to expand (inline) such
  // expressions when a String field is extracted from an array of
  // records, reporting the internal error "failed to expand string".
  function getSurfaceNames
    input CFDSurfaceIdentifier surIde[:] "Surface identifiers";
    output String name[size(surIde,1)] "Names of the surfaces";
  algorithm
    for i in 1:size(surIde,1) loop
      name[i] := surIde[i].name;
    end for;
  end getSurfaceNames;

  ///////////////////////////////////////////////////////////////////////////
  // Function that returns strings that are not unique.
  function returnNonUniqueStrings
    input Integer n(min=2) "Number entries";
    input Boolean ideNam[n - 1]
      "Flag that is set to true if the name is used more than once";
    input String names[n] "Names";
    output String s "String with non-unique names";
  algorithm
    s := "";
    for i in 1:n - 1 loop
      if ideNam[i] then
        s := s + "\n  '" + names[i] + "'";
      end if;
    end for;
  end returnNonUniqueStrings;

  // Note: Dymola has problems with string operations (concatenation, function
  // calls returning strings) inside algorithm sections used during translation.
  // Therefore assertStringsAreUnique only performs a boolean uniqueness check
  // and emits a fixed error message without enumerating the duplicates.
  // See the commented-out block in CFDExchange.mo for background.
  impure function assertStringsAreUnique
    input String descriptiveName
      "Descriptive name of what is tested, such as 'sensor' or 'ports'";
    input Integer n(min=2) "Number of strings";
    input String names[n] "Names";
  protected
    Boolean anyDuplicate
      "True if at least one name appears more than once";

  algorithm
    anyDuplicate := false;
    if n > 1 then
      for i in 1:n-1 loop
        for j in i+1:n loop
          if Modelica.Utilities.Strings.isEqual(names[i], names[j]) then
            anyDuplicate := true;
          end if;
        end for; // j
      end for; // i
      assert(not anyDuplicate,
        "For the CFD interface, all " + descriptiveName +
        " names must be unique within each room. Check the room model parameters.");
    end if;
  end assertStringsAreUnique;

initial algorithm
  // Diagnostics output - must be in an algorithm section because
  // Modelica.Utilities.Streams.print has side-effects and is not
  // allowed in equation sections.
  if verbose then
    Modelica.Utilities.Streams.print(string="
CFDExchange has the following surfaces:");
    for i in 1:nSur loop
      Modelica.Utilities.Streams.print(string="
  name = " + surNam[i] + "
  A    = " + String(surIde[i].A) + " [m2]
  tilt = " + String(surIde[i].til*180/Modelica.Constants.pi) + " [deg]");
    end for;
    if haveSensor then
      Modelica.Utilities.Streams.print(string="
CFDExchange has the following sensors:");
      for i in 1:nSen loop
        Modelica.Utilities.Streams.print(string="  " + sensorName[i]);
      end for;
    else
      Modelica.Utilities.Streams.print(string="CFDExchange has no sensors.");
    end if;
  end if;

  // Assert that the surface, sensor and ports have a name,
  // and that that name is unique.
  // Otherwise, stop with an error.
  assertStringsAreUnique(descriptiveName="surface",
                         n=nSur,
                         names=surNam);
  assertStringsAreUnique(descriptiveName="sensor",
                         n=nSen,
                         names=sensorName);
  assertStringsAreUnique(descriptiveName="ports",
                         n=nPorts,
                         names=portName);

  assert(min(flaWri) >= 0 and max(flaWri) <= 2,
    "Parameter flaWri is out of range. Each element must be 0, 1, or 2.");

initial equation
  // Assignment of parameters and start values
  uInt = zeros(nWri);
  uIntPre = zeros(nWri);

  // Assign uWri and y. This avoids a translation warning in Dymola
  // as otherwise, not all initial values are specified.
  // However, uWri and y are only used below in the body of the 'when'
  // block after they have been assigned.
  uWri = u;
  y=yFixed;

  modTimRea = time;

equation
  for i in 1:nWri loop
    der(uInt[i]) = if (flaWri[i] > 0) then u[i] else 0;
  end for;

  when sampleTrigger then
    // Compute value that will be sent to the CFD interface
    for i in 1:nWri loop
      if (flaWri[i] == 0) then
        uWri[i] =  pre(u[i]);
      elseif (flaWri[i] == 1) then
        if (time<startTime+0.1*samplePeriod) then
           uWri[i] =  pre(u[i]);
           // Set the correct initial data
        else
         //  uWri[i] = pre(u[i]);
          uWri[i] =  (uInt[i] - pre(uIntPre[i]))/samplePeriod;
        // Average value over the sampling interval
        end if;
      else
        uWri[i] =  uInt[i] - pre(uIntPre[i]);
        // Integral over the sampling interval
      end if;
    end for;

    // Store current value of integral
    uIntPre = uInt;
  end when;

  annotation (
    Documentation(info="<html>
<p>
This partial model derives from <a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.CFDExchange\">
Buildings.ThermalZones.Detailed.BaseClasses.CFDExchange</a>, which samples interface variables and exchanges data with the CFD or ISAT code.
</p>
<p>
For a documentation of the exchange parameters and variables, see
<a href=\"modelica://Buildings.ThermalZones.Detailed.UsersGuide.CFD\">
Buildings.ThermalZones.Detailed.UsersGuide.CFD</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2026, by fix for Dymola translation error:<br/>
Introduced the protected parameter <code>surNam</code> and the function
<code>getSurfaceNames</code>, which extracts the <code>name</code> field of
the array of records <code>surIde</code> using an explicit <code>for</code>
loop. Replaced all uses of the array projections <code>surIde.name</code>
and <code>surIde[:].name</code> (in <code>assertStringsAreUnique</code> and
in the diagnostic <code>Modelica.Utilities.Streams.print</code> statement)
with <code>surNam</code>. Dymola's code generator failed to expand
(inline) such array projections when a <code>String</code> field is
extracted from an array of records, reporting the internal error
\"failed to expand string\". This is also fixed in
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.CFDExchange\">
Buildings.ThermalZones.Detailed.BaseClasses.CFDExchange</a> and
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.ISATExchange\">
Buildings.ThermalZones.Detailed.BaseClasses.ISATExchange</a>, which now use
<code>surNam</code> instead of <code>surIde[:].name</code> in the call to
<code>sendParameters</code>.
</li>
<li>
April 5, 2020, by Xu Han, Wangda Zuo and Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialExchange;
