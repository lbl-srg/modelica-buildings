within Buildings.Experimental.EnergyPlus.BaseClasses.Validation;
model FMUZoneAdapterZones3
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
    annotation (Placement(transformation(extent={{62,24},{82,44}})));
  Modelica.Blocks.Sources.RealExpression X_w(y=0.01) "Zone absolute humidity"
    annotation (Placement(transformation(extent={{-88,44},{-68,64}})));
  Modelica.Blocks.Sources.RealExpression mIn_flow(y=0) "Inlet mass flow rate"
    annotation (Placement(transformation(extent={{-88,24},{-68,44}})));
  Modelica.Blocks.Math.Gain mOut_flow(k=-1) "Outlet mass flow rate"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Sources.RealExpression TIn[2](
    each y=293.15) "Inlet temperature"
    annotation (Placement(transformation(extent={{-88,-26},{-68,-6}})));
  Modelica.Blocks.Sources.RealExpression QGaiRad_flow(
    y=0) "Radiative heat gain for the zone"
    annotation (Placement(transformation(extent={{-88,-46},{-68,-26}})));
  Modelica.Blocks.Continuous.Integrator TZonCor(
    k=1/CZon,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=294.15,
    y(final unit="K", displayUnit="degC")) "Zone air temperature"
    annotation (Placement(transformation(extent={{0,66},{20,86}})));
  Buildings.Experimental.EnergyPlus.BaseClasses.FMUZoneAdapter fmuZonSou(
    final idfName=idfName,
    final weaName=weaName,
    final zoneName="South_ZN",
    final nFluPor=2,
    samplePeriod=60) "Adapter to EnergyPlus"
    annotation (Placement(transformation(extent={{60,-6},{80,14}})));
  Modelica.Blocks.Continuous.Integrator TZonSou(
    k=1/CZon,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=294.15,
    y(final unit="K", displayUnit="degC")) "Zone air temperature"
    annotation (Placement(transformation(extent={{12,-36},{32,-16}})));
  Modelica.Blocks.Sources.RealExpression QCon(y=CZon) "Convective gain"
    annotation (Placement(transformation(extent={{-66,72},{-46,92}})));
  Buildings.Experimental.EnergyPlus.BaseClasses.FMUZoneAdapter fmuZonNor(
    final idfName=idfName,
    final weaName=weaName,
    final zoneName="North_ZN",
    final nFluPor=2,
    samplePeriod=60) "Adapter to EnergyPlus"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Modelica.Blocks.Continuous.Integrator TZonNor(
    k=1/CZon,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=294.15,
    y(final unit="K", displayUnit="degC")) "Zone air temperature"
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
equation
  connect(X_w.y, fmuZonCor.X_w) annotation (Line(points={{-67,54},{-28,54},{-28,
          38},{60,38}},
                      color={0,0,127}));
  connect(fmuZonCor.m_flow[1], mIn_flow.y) annotation (Line(points={{60,33},{12,
          33},{12,34},{-67,34}},    color={0,0,127}));
  connect(mOut_flow.u, mIn_flow.y) annotation (Line(points={{-62,20},{-64,20},{-64,
          34},{-67,34}},    color={0,0,127}));
  connect(mOut_flow.y, fmuZonCor.m_flow[2]) annotation (Line(points={{-39,20},{-10,
          20},{-10,35},{60,35}},   color={0,0,127}));
  connect(TIn.y, fmuZonCor.TInlet) annotation (Line(points={{-67,-16},{0,-16},{0,
          30},{60,30}},   color={0,0,127}));
  connect(fmuZonCor.QGaiRad_flow, QGaiRad_flow.y) annotation (Line(points={{60,26},
          {-4,26},{-4,-36},{-67,-36}},   color={0,0,127}));
  connect(X_w.y, fmuZonSou.X_w) annotation (Line(points={{-67,54},{-28,54},{-28,
          8},{58,8}},     color={0,0,127}));
  connect(fmuZonSou.m_flow[1], mIn_flow.y) annotation (Line(points={{58,3},{-24,
          3},{-24,34},{-67,34}},     color={0,0,127}));
  connect(mOut_flow.y, fmuZonSou.m_flow[2]) annotation (Line(points={{-39,20},{-10,
          20},{-10,5},{58,5}},         color={0,0,127}));
  connect(TIn.y, fmuZonSou.TInlet) annotation (Line(points={{-67,-16},{0,-16},{0,
          0},{58,0}},       color={0,0,127}));
  connect(fmuZonSou.QGaiRad_flow, QGaiRad_flow.y) annotation (Line(points={{58,-4},
          {-4,-4},{-4,-36},{-67,-36}},     color={0,0,127}));
  connect(TZonCor.y, fmuZonCor.T)
    annotation (Line(points={{21,76},{36,76},{36,42},{60,42}},
                                                             color={0,0,127}));
  connect(TZonSou.y, fmuZonSou.T) annotation (Line(points={{33,-26},{40,-26},{40,
          12},{58,12}},      color={0,0,127}));
  connect(QCon.y, TZonCor.u) annotation (Line(points={{-45,82},{-24,82},{-24,76},
          {-2,76}},color={0,0,127}));
  connect(QCon.y, TZonSou.u) annotation (Line(points={{-45,82},{-32,82},{-32,-26},
          {10,-26}}, color={0,0,127}));
  connect(X_w.y, fmuZonNor.X_w) annotation (Line(points={{-67,54},{-20,54},{-20,
          -46},{58,-46}}, color={0,0,127}));
  connect(fmuZonNor.m_flow[1], mIn_flow.y) annotation (Line(points={{58,-51},{-24,
          -51},{-24,34},{-67,34}}, color={0,0,127}));
  connect(mOut_flow.y, fmuZonNor.m_flow[2]) annotation (Line(points={{-39,20},{-10,
          20},{-10,-49},{58,-49}}, color={0,0,127}));
  connect(TIn.y, fmuZonNor.TInlet) annotation (Line(points={{-67,-16},{0,-16},{0,
          -54},{58,-54}}, color={0,0,127}));
  connect(fmuZonNor.QGaiRad_flow, QGaiRad_flow.y) annotation (Line(points={{58,-58},
          {-4,-58},{-4,-36},{-67,-36}}, color={0,0,127}));
  connect(TZonNor.y, fmuZonNor.T) annotation (Line(points={{31,-80},{48,-80},{48,
          -42},{58,-42}}, color={0,0,127}));
  connect(TZonNor.u, QCon.y) annotation (Line(points={{8,-80},{-32,-80},{-32,82},
          {-45,82}}, color={0,0,127}));
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
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/EnergyPlus/BaseClasses/Validation/FMUZoneAdapterZones3.mos"
        "Simulate and plot"),
experiment(
      StopTime=240,
      Tolerance=1e-06));
end FMUZoneAdapterZones3;
