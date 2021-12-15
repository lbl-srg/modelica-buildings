within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Examples;
model InternalHEXOneUTube
  "Comparison of the effective borehole thermal resistance  from the thermal network of Bauer et al. with the resistance calculated by singleUTubeResistances (ref)"
  extends Modelica.Icons.Example;

  parameter Integer nSeg(min=1) = 10
    "Number of segments to use in vertical discretization of the boreholes";
  parameter Modelica.Units.SI.Length hSeg=borFieDat.conDat.hBor/nSeg
    "Length of the internal heat exchanger";

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalHEXOneUTube
    intHex(
    redeclare package Medium = Medium,
    hSeg=hSeg,
    dp1_nominal=10,
    dp2_nominal=10,
    borFieDat=borFieDat,
    m1_flow_nominal=borFieDat.conDat.mBor_flow_nominal,
    m2_flow_nominal=borFieDat.conDat.mBor_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TFlu_start=285.15,
    TGro_start=285.15)
    annotation (Placement(transformation(extent={{-10,-12},{10,10}})));

  Buildings.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=273.15
         + 12)
    annotation (Placement(transformation(extent={{-22,30},{-2,50}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(nPorts=1,
    redeclare package Medium = Medium,
    m_flow=borFieDat.conDat.mBor_flow_nominal,
    T=293.15)
    annotation (Placement(transformation(extent={{-48,-4},{-28,16}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary1(nPorts=1,
    redeclare package Medium = Medium,
    m_flow=borFieDat.conDat.mBor_flow_nominal,
    T=293.15)
    annotation (Placement(transformation(extent={{54,4},{34,-16}})));
  Buildings.Fluid.Sources.Boundary_pT bou(nPorts=2, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-48,-34},{-28,-14}})));
  Real Rb_sim(unit="(m.K)/W") = ((senTem.T + senTem1.T)/2 - intHex.port_wall.T)/max(-intHex.port_wall.Q_flow / hSeg,1);
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Medium, m_flow_nominal=borFieDat.conDat.mBor_flow_nominal)
    annotation (Placement(transformation(extent={{16,0},{28,12}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package Medium =
        Medium, m_flow_nominal=borFieDat.conDat.mBor_flow_nominal)
    annotation (Placement(transformation(extent={{-28,-12},{-16,0}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Rb_sim)
    annotation (Placement(transformation(extent={{-10,-58},{10,-38}})));
  Modelica.Blocks.Sources.Constant Rb_ref(k=0.082399)
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  Modelica.Blocks.Math.Add error(k2=-1)
    annotation (Placement(transformation(extent={{22,-70},{42,-50}})));
  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example
    borFieDat(conDat=
        Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        use_Rb=false))
    "Borefield data"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation

  connect(boundary1.ports[1], intHex.port_a2)
    annotation (Line(points={{34,-6},{10,-6},{10,-7.6}},
                                                       color={0,127,255}));
  connect(boundary.ports[1], intHex.port_a1)
    annotation (Line(points={{-28,6},{-10,6},{-10,5.6}},
                                                       color={0,127,255}));
  connect(bou.ports[1], senTem.port_b) annotation (Line(points={{-28,-22},{70,-22},
          {70,6},{28,6}}, color={0,127,255}));
  connect(senTem.port_a, intHex.port_b1)
    annotation (Line(points={{16,6},{10,6},{10,5.6}},
                                                    color={0,127,255}));
  connect(senTem1.port_a, bou.ports[2]) annotation (Line(points={{-28,-6},{-28,-26},
          {-28,-26}}, color={0,127,255}));
  connect(senTem1.port_b, intHex.port_b2)
    annotation (Line(points={{-16,-6},{-10,-6},{-10,-7.6}},
                                                          color={0,127,255}));
  connect(realExpression.y, error.u1) annotation (Line(points={{11,-48},{14,-48},
          {14,-54},{20,-54}}, color={0,0,127}));
  connect(Rb_ref.y, error.u2) annotation (Line(points={{11,-70},{14,-70},{14,-66},
          {20,-66}}, color={0,0,127}));
  connect(fixedTemperature.port, intHex.port_wall)
    annotation (Line(points={{-2,40},{0,40},{0,10}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=100000, Tolerance=1e-6),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/BaseClasses/Examples/InternalHEXOneUTube.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This example simulates the interior thermal behavior of a single U-tube borehole segment.
</html>", revisions="<html>
<ul>
<li>
May 15, 2019, by Jianjun Hu:<br/>
Replaced fluid source FixedBoundary with Boundary_pT. This is for 
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\"> #1072</a>.
</li>
<li>
June 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end InternalHEXOneUTube;
