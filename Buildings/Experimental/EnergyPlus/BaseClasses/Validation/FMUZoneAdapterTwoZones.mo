within Buildings.Experimental.EnergyPlus.BaseClasses.Validation;
model FMUZoneAdapterTwoZones
  "Validation model for the class and functions that instantiate and communicate with EnergyPlus"
  extends Modelica.Icons.Example;
  parameter String idfName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/Data/Experimental/EnergyPlus/Validation/RefBldgSmallOfficeNew2004_Chicago.idf")
    "Name of the IDF file";
  parameter String weaName = Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")
    "Name of the weather file";
  parameter Modelica.SIunits.HeatCapacity CZon = 6*6*2.7*1.2*1006 "Heat capacity of zone air";

  Buildings.Experimental.EnergyPlus.BaseClasses.FMUZoneAdapter fmuZonCor(
    final idfName=idfName,
    final weaName=weaName,
    final zoneName="Core_ZN",
    final nFluPor=2,
    samplePeriod=60) "Adapter to EnergyPlus"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.RealExpression X_w(y=0.01) "Zone absolute humidity"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.RealExpression mIn_flow(y=0) "Inlet mass flow rate"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Math.Gain mOut_flow(k=-1) "Outlet mass flow rate"
    annotation (Placement(transformation(extent={{-48,-26},{-28,-6}})));
  Modelica.Blocks.Sources.RealExpression TIn[2](
    each y=293.15) "Inlet temperature"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.RealExpression QGaiRad_flow(
    y=0) "Radiative heat gain for the zone"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Continuous.Integrator TZonCor(
    k=1/CZon,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=295.15,
    y(unit="K", displayUnit="degC")) "Zone air temperature"
    annotation (Placement(transformation(extent={{8,32},{28,52}})));
  Buildings.Experimental.EnergyPlus.BaseClasses.FMUZoneAdapter fmuZonSou(
    final idfName=idfName,
    final weaName=weaName,
    final zoneName="South_ZN",
    final nFluPor=2,
    samplePeriod=60) "Adapter to EnergyPlus"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Modelica.Blocks.Continuous.Integrator TZonSou(
    k=1/CZon,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=295.15,
    y(unit="K", displayUnit="degC")) "Zone air temperature"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
equation
  connect(X_w.y, fmuZonCor.X_w) annotation (Line(points={{-59,20},{-20,20},{-20,
          4},{58,4}}, color={0,0,127}));
  connect(fmuZonCor.m_flow[1], mIn_flow.y) annotation (Line(points={{58,-1},{
          -15,-1},{-15,0},{-59,0}}, color={0,0,127}));
  connect(mOut_flow.u, mIn_flow.y) annotation (Line(points={{-50,-16},{-56,-16},
          {-56,0},{-59,0}}, color={0,0,127}));
  connect(mOut_flow.y, fmuZonCor.m_flow[2]) annotation (Line(points={{-27,-16},
          {-2,-16},{-2,1},{58,1}}, color={0,0,127}));
  connect(TIn.y, fmuZonCor.TInlet) annotation (Line(points={{-59,-50},{0,-50},{
          0,-4},{58,-4}}, color={0,0,127}));
  connect(fmuZonCor.QGaiRad_flow, QGaiRad_flow.y) annotation (Line(points={{58,
          -8},{4,-8},{4,-70},{-59,-70}}, color={0,0,127}));
  connect(fmuZonCor.QCon_flow, TZonCor.u) annotation (Line(points={{81,2},{88,2},
          {88,60},{-10,60},{-10,42},{6,42}}, color={0,0,127}));
  connect(X_w.y, fmuZonSou.X_w) annotation (Line(points={{-59,20},{-20,20},{-20,
          -26},{58,-26}}, color={0,0,127}));
  connect(fmuZonSou.m_flow[1], mIn_flow.y) annotation (Line(points={{58,-31},{
          -15,-31},{-15,0},{-59,0}}, color={0,0,127}));
  connect(mOut_flow.y, fmuZonSou.m_flow[2]) annotation (Line(points={{-27,-16},
          {-2,-16},{-2,-29},{58,-29}}, color={0,0,127}));
  connect(TIn.y, fmuZonSou.TInlet) annotation (Line(points={{-59,-50},{0,-50},{
          0,-34},{58,-34}}, color={0,0,127}));
  connect(fmuZonSou.QGaiRad_flow, QGaiRad_flow.y) annotation (Line(points={{58,
          -38},{4,-38},{4,-70},{-59,-70}}, color={0,0,127}));
  connect(fmuZonSou.QCon_flow, TZonSou.u) annotation (Line(points={{81,-28},{90,
          -28},{90,-80},{12,-80},{12,-60},{18,-60}}, color={0,0,127}));
  connect(TZonCor.y, fmuZonCor.T)
    annotation (Line(points={{29,42},{44,42},{44,8},{58,8}}, color={0,0,127}));
  connect(TZonSou.y, fmuZonSou.T) annotation (Line(points={{41,-60},{48,-60},{
          48,-22},{58,-22}}, color={0,0,127}));
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
end FMUZoneAdapterTwoZones;
