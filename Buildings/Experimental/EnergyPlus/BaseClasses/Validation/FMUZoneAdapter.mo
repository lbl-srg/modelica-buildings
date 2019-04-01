within Buildings.Experimental.EnergyPlus.BaseClasses.Validation;
model FMUZoneAdapter
  "Validation model for the class and functions that instantiate and communicate with EnergyPlus"
  extends Modelica.Icons.Example;
  parameter String idfName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/Data/Experimental/EnergyPlus/Validation/RefBldgSmallOfficeNew2004_Chicago.idf")
    "Name of the IDF file";
  parameter String weaName = Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")
    "Name of the weather file";
  parameter Modelica.SIunits.HeatCapacity CZon = 6*6*2.7*1.2*1006 "Heat capacity of zone air";

  Buildings.Experimental.EnergyPlus.BaseClasses.FMUZoneAdapter fmuZon(
    final idfName=idfName,
    final weaName=weaName,
    final zoneName="Core_ZN",
    final nFluPor=2) "Adapter to EnergyPlus"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.RealExpression TZone(y=293.15) "Zone air temperature"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.RealExpression X_w(y=0.01) "Zone absolute humidity"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.RealExpression mIn_flow(y=0) "Inlet mass flow rate"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Math.Gain mOut_flow(k=-1) "Outlet mass flow rate"
    annotation (Placement(transformation(extent={{-50,-32},{-30,-12}})));
  Modelica.Blocks.Sources.RealExpression TIn[2](
    each y=293.15) "Inlet temperature"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.RealExpression QGaiRad_flow(
    y=0) "Radiative heat gain for the zone"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Continuous.Integrator TZon(
    k=1/CZon,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=293.15,
    y(unit="K", displayUnit="degC")) "Zone air temperature"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
equation
  connect(X_w.y, fmuZon.X_w) annotation (Line(points={{-59,20},{-36,20},{-36,4},
          {18,4}},  color={0,0,127}));
  connect(fmuZon.m_flow[1], mIn_flow.y) annotation (Line(points={{18,-1},{-35,-1},
          {-35,0},{-59,0}}, color={0,0,127}));
  connect(mOut_flow.u, mIn_flow.y) annotation (Line(points={{-52,-22},{-56,-22},
          {-56,0},{-59,0}}, color={0,0,127}));
  connect(mOut_flow.y, fmuZon.m_flow[2]) annotation (Line(points={{-29,-22},{-22,
          -22},{-22,1},{18,1}},  color={0,0,127}));
  connect(TIn.y, fmuZon.TInlet) annotation (Line(points={{-59,-50},{-20,-50},{-20,
          -4},{18,-4}},  color={0,0,127}));
  connect(fmuZon.QGaiRad_flow, QGaiRad_flow.y) annotation (Line(points={{18,-8},
          {-16,-8},{-16,-70},{-59,-70}}, color={0,0,127}));
  connect(TZon.y, fmuZon.T)
    annotation (Line(points={{1,40},{10,40},{10,8},{18,8}}, color={0,0,127}));
  connect(fmuZon.QCon_flow, TZon.u) annotation (Line(points={{41,2},{50,2},{50,60},
          {-30,60},{-30,40},{-22,40}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Validation model that communicates with EnergyPlus.
</p>
</html>", revisions="<html>
<ul><li>
March 19, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/EnergyPlus/BaseClasses/Validation/FMUZoneAdapter.mos"
        "Simulate and plot"),
experiment(
      StopTime=120,
      Tolerance=1e-06));
end FMUZoneAdapter;
