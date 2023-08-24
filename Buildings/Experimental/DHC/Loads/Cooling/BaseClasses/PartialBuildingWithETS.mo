within Buildings.Experimental.DHC.Loads.Cooling.BaseClasses;
model PartialBuildingWithETS
  "Partial model with ETS model for cooling and partial building model"
  extends
    Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuildingWithPartialETS(
      nPorts_chiWat=1,
      redeclare Buildings.Experimental.DHC.EnergyTransferStations.Cooling.Direct ets(
      final mBui_flow_nominal=mBui_flow_nominal,
      final controllerType=controllerType,
      final k=k,
      final Ti=Ti,
      final Td=Td,
      final yMax=yMax,
      final yMin=yMin));

  parameter Modelica.Units.SI.MassFlowRate mBui_flow_nominal(
    final min=0,
    final start=0.5)
    "Nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpSup(
    final min=0,
    displayUnit="Pa")=5000
    "Pressure drop in the ETS supply side";
  parameter Modelica.Units.SI.PressureDifference dpRet(
    final min=0,
    displayUnit="Pa")=5000
    "Pressure drop in the ETS return side";
  // Controller parameters
  parameter Modelica.Blocks.Types.SimpleController controllerType=Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="PID controller"));
  parameter Real k(
    final min=0,
    final unit="1")=0.1
    "Gain of controller"
    annotation (Dialog(group="PID controller"));
  parameter Modelica.Units.SI.Time Ti(
    final min=Modelica.Constants.small)=60
    "Time constant of integrator block"
    annotation (Dialog(group="PID controller",enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time Td(
    final min=0)=0.1
    "Time constant of derivative block"
    annotation (Dialog(group="PID controller",enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yMax(
    final start=1)=1
    "Upper limit of output"
    annotation (Dialog(group="PID controller"));
  parameter Real yMin=0
    "Lower limit of output"
    annotation (Dialog(group="PID controller"));
  Modelica.Blocks.Interfaces.RealInput TSetDisRet(
     final unit="K",
     displayUnit="degC")
    "Setpoint for the minimum district return temperature"
    annotation (Placement(transformation(extent={{-340,20},{-300,-20}}),
        iconTransformation(extent={{-120,60},{-100,80}})));
equation
  connect(TSetDisRet, ets.TSetDisRet) annotation (Line(points={{-320,0},{-64,0},
          {-64,-56},{-31.8,-56}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This model is composed of a direct controlled energy transfer station model for cooling
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Cooling.Direct\">
Buildings.Experimental.DHC.EnergyTransferStations.Cooling.Direct</a>
connected to a repleacable building load model.
</p>
</html>", revisions="<html>
<ul>
<li>
December 23, 2022, by Kathryn Hinkelman:<br>
Revised ETS from direct uncontrolled to direct controlled.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2912\">#2912</a>.
</li>
</ul>
<ul>
<li>March 20, 2022, by Chengnan Shi:<br>First implementation. </li>
</ul>
</html>"));
end PartialBuildingWithETS;
