within Buildings.Experimental.DHC.Examples.Cooling.BaseClasses.Examples;
model BuildingTimeSeriesWithETSCooling
  "Example for testing the building model with prescribed cooling load profile"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  Buildings.Experimental.DHC.Examples.Cooling.BaseClasses.BuildingTimeSeriesWithETSCooling
    buiWitETS(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    filNam="modelica://Buildings/Resources/Data/Experimental/DHC/Examples/Cooling/BaseClasses/Examples/Loads.txt",
    TSetDisRet(displayUnit="K"),
    mDis_flow_nominal=buiWitETS.mBui_flow_nominal,
    mByp_flow_nominal=0.01) "Building with ETS model"
    annotation (Placement(transformation(extent={{-40,-8},{-20,12}})));

  Buildings.Fluid.Sources.Boundary_pT watSin(
    redeclare package Medium = Medium,
    p=300000,
    nPorts=1) "Water sink"
    annotation (Placement(transformation(extent={{60,20},{40,40}})));

  Buildings.Fluid.Sources.Boundary_pT watSou(
    redeclare package Medium = Medium,
    p=350000,
    T=280.15,
    nPorts=1) "Water source"
    annotation (Placement(transformation(extent={{60,-40},{40,-20}})));
initial equation
  Modelica.Utilities.Streams.print(
    "Warning:\n  In " + getInstanceName() +
    ": This model is a beta version and is not fully validated yet.");

equation
  connect(buiWitETS.port_b, watSin.ports[1]) annotation (Line(points={{-20,2},{-12,
          2},{-12,30},{40,30}}, color={0,127,255}));
  connect(watSou.ports[1], buiWitETS.port_a) annotation (Line(points={{40,-30},{
          -50,-30},{-50,2},{-40,2}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Experimental/DHC/Examples/Cooling/BaseClasses/Examples/BuildingTimeSeriesWithETSCooling.mos"
        "Simulate and Plot"),
    experiment(StopTime=86400, __Dymola_Algorithm="cvode"),
    Documentation(info="<html>
<p>
This model validates the model 
<a href=\"modelica://Buildings.Experimental.DHC.Examples.Cooling.BaseClasses.BuildingTimeSeriesWithETSCooling\">
Buildings.Experimental.DHC.Examples.Cooling.BaseClasses.BuildingTimeSeriesWithETSCooling</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 13, 2020 by Jing Wang:<br/>
First implementation. 
</li>
</ul>
</html>"));
end BuildingTimeSeriesWithETSCooling;
