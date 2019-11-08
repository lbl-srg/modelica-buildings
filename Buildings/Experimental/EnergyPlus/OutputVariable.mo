within Buildings.Experimental.EnergyPlus;
model OutputVariable
  "Block to read an EnergyPlus output variable for use in Modelica"
  extends Modelica.Blocks.Icons.Block;

  outer Buildings.Experimental.EnergyPlus.Building building "Building-level declarations";

  parameter String key
    "EnergyPlus key of the output variable";
  parameter String name
    "EnergyPlus name of the output variable as in the EnergyPlus .rdd or .mdd file";

  discrete Modelica.Blocks.Interfaces.RealOutput y "Output received from EnergyPlus" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));

protected
  constant String modelicaNameBuilding = building.modelicaNameBuilding
    "Name of the building to which this output variable belongs to"
    annotation(HideResult=true);
  constant String modelicaNameOutputVariable = getInstanceName()
    "Name of this instance"
    annotation(HideResult=true);

  final parameter String idfName=building.idfName "Name of the IDF file that contains this zone";
  final parameter String weaName=building.weaName "Name of the EnergyPlus weather file";

  final parameter Boolean usePrecompiledFMU = building.usePrecompiledFMU
    "Set to true to use pre-compiled FMU with name specified by fmuName"
    annotation(Dialog(tab="Debug"));

  final parameter String fmuName=building.fmuName
    "Specify if a pre-compiled FMU should be used instead of EnergyPlus (mainly for development)"
    annotation(Dialog(tab="Debug"));

  final parameter Buildings.Experimental.EnergyPlus.Types.Verbosity verbosity=building.verbosity
    "Verbosity of EnergyPlus output"
    annotation(Dialog(tab="Debug"));


  Buildings.Experimental.EnergyPlus.BaseClasses.FMUOutputVariableClass adapter=
      Buildings.Experimental.EnergyPlus.BaseClasses.FMUOutputVariableClass(
      modelicaNameBuilding=modelicaNameBuilding,
      modelicaNameOutputVariable=modelicaNameOutputVariable,
      idfName=idfName,
      weaName=weaName,
      iddName=Buildings.Experimental.EnergyPlus.BaseClasses.iddName,
      outputKey=key,
      outputName=name,
      usePrecompiledFMU=usePrecompiledFMU,
      fmuName=fmuName,
      buildingsLibraryRoot=Buildings.Experimental.EnergyPlus.BaseClasses.buildingsLibraryRoot,
      verbosity=verbosity) "Class to communicate with EnergyPlus";

  parameter Modelica.SIunits.Time startTime(fixed=false) "Simulation start time";

  Modelica.SIunits.Time tNext(start=startTime, fixed=true) "Next sampling time";

  Integer counter "Counter for number of calls to EnergyPlus during time steps";

  function round
    input Real u;
    input Real accuracy;
    output Real y;

  algorithm
    y :=if (u > 0) then floor(u/accuracy + 0.5)*accuracy else ceil(u/accuracy - 0.5)*accuracy;
  end round;

initial equation
  assert(not usePrecompiledFMU, "Use of pre-compiled FMU is not supported for block OutputVariable.");

  startTime =  time;
  counter = 0;
  Buildings.Experimental.EnergyPlus.BaseClasses.outputVariableInitialize(
    adapter = adapter,
    startTime = time);

equation
  // The 'not initial()' triggers one sample when the continuous time simulation starts.
  // This is required for the correct event handling. Otherwise the regression tests will fail.
 // when {initial(), not initial(), time >= pre(tNext)} then
  when {initial(), time >= pre(tNext), not initial()} then
    (y, tNext)  =Buildings.Experimental.EnergyPlus.BaseClasses.outputVariableExchange(
      adapter,
      initial(),
      round(time, 1E-3));
    counter = pre(counter) + 1;
  end when;

  annotation (
  defaultComponentName="out",
  Icon(graphics={
          Bitmap(extent={{-18,-112},{84,-10}},
          fileName="modelica://Buildings/Resources/Images/Experimental/EnergyPlus/EnergyPlusLogo.png",
          visible=not usePrecompiledFMU),
        Text(
          extent={{-88,84},{80,50}},
          lineColor={0,0,255},
          textString="%key"),
        Text(
          extent={{-86,36},{80,2}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p>
Block that retrieves an output variable from EnergyPlus.
</p>
<p>
This model instantiates an FMU with the name <code>idfName</code> and
reads at every EnergyPlus zone time step the output variable specified
by the parameters <code>outputKey</code> and <code>outputName</code>.
These parameters are the values for the EnergyPlus variable key and name,
which can be found in the EnergyPlus result dictionary file (<code>.rdd</code> file)
or the EnergyPlus meter dictionary file (<code>.mdd</code> file).
</p>
<p>
The variable of the output <code>y</code> has Modelica SI units, as declared in
<a href=\"modelica://Modelica.SIunits\">Modelica.SIunits</a>.
For example, temperatures will be in Kelvin, and mass flow rates will be in
<code>kg/s</code>.
</p>
</html>"));
end OutputVariable;
