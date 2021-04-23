within Buildings.Fluid.Geothermal.Borefields.Validation;
model Sandbox "Validation of BorefieldOneUTube based on the experiment of Beier et al. (2011)"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  parameter Modelica.SIunits.Temperature T_start = 273.15 + 22.09
    "Initial temperature of the sandbox";

  // mSenFac is set to its numerical value because it is a constant in the borehole model.
  // mSenFac = 1 +
  //  (1.8e6*Modelica.Constants.pi*(borFieDat.conDat.rTub^2
  //        -(borFieDat.conDat.rTub-borFieDat.conDat.eTub)^2)
  //        +2.4e6*2*Modelica.Constants.pi*borFieDat.conDat.rBor*0.002/2)
  //        /(4.2e6*Modelica.Constants.pi*(borFieDat.conDat.rTub-borFieDat.conDat.eTub)^2)

  constant Real mSenFac = 1.59186
  "Scaling factor for the borehole capacitances, modified to account for the thermal mass of the pipes and the borehole casing";

  Buildings.Fluid.Geothermal.Borefields.OneUTube borHol(
    redeclare package Medium = Medium, borFieDat=
    borFieDat,
    tLoaAgg=60,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    mSenFac=mSenFac,
    TExt0_start=T_start,
    dT_dz=0) "Borehole"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium,
    T_start=T_start,
    addPowerToMedium=false,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true,
    inputType=Buildings.Fluid.Types.InputType.Constant)
    annotation (Placement(transformation(extent={{-20,-10},{0,-30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBorFieIn(
    redeclare package Medium = Medium,
    T_start=T_start,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Inlet temperature of the borefield"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TBorFieOut(
    redeclare package Medium = Medium,
    T_start=T_start,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    tau=0)
    "Outlet temperature of the borefield"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));
  parameter Buildings.Fluid.Geothermal.Borefields.Validation.BaseClasses.SandBox_Borefield borFieDat "Borefield data"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Fluid.Sources.Boundary_ph sin(
    redeclare package Medium = Medium,
    nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Modelica.Blocks.Sources.CombiTimeTable sandBoxMea(
    tableOnFile=true,
    tableName="data",
    offset={0,0,0},
    columns={2,3,4},
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Fluid/Geothermal/Borefields/HeatTransfer/Validation/Beier_Smith_Spitler_2011_SandBox.txt"))
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = Medium,
    dp_nominal=10000,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=T_start,
    Q_flow_nominal=1056,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    m_flow(start=borFieDat.conDat.mBorFie_flow_nominal),
    p_start=100000) "Heater"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
equation
  connect(TBorFieIn.port_b, borHol.port_a)
    annotation (Line(points={{30,-20},{40,-20}},   color={0,127,255}));
  connect(borHol.port_b, TBorFieOut.port_a)
    annotation (Line(points={{60,-20},{70,-20}},          color={0,127,255}));
  connect(pum.port_b, TBorFieIn.port_a) annotation (Line(points={{0,-20},{10,-20}},
                                         color={0,127,255}));
  connect(sin.ports[1], TBorFieOut.port_b) annotation (Line(points={{80,10},{100,
          10},{100,-20},{90,-20}},color={0,127,255}));
  connect(hea.port_b, pum.port_a)
    annotation (Line(points={{-30,-20},{-20,-20}},     color={0,127,255}));
  connect(hea.port_a, TBorFieOut.port_b) annotation (Line(points={{-50,-20},{-100,
          -20},{-100,40},{100,40},{100,-20},{90,-20}},
                                      color={0,127,255}));
  connect(sandBoxMea.y[3], hea.u) annotation (Line(points={{-69,0},{-58,0},{-58,
          -14},{-52,-14}},
                        color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=186360),
  __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/Validation/Sandbox.mos"
        "Simulate and Plot"),
Documentation(info="<html>
<p>
This validation case simulates the experiment of Beier et al. (2011). Measured
experimental data is taken from the reference.
</p>
<p>
The experiment consists in the injection of heat at an average rate of 1142 W
in a 18 m long borehole over a period 52 h. Dimensions and thermal properties
reported by Beier et al. (2011) are used in the model. The authors conducted
multiple independent measurements of soil thermal conductivity. The average of
reported values (2.88 W/m-K) is used here. Finally, the filling material thermal
capacity and density was not reported. Values were chosen from the estimated
volumetric heat capacity used by Pasquier and Marcotte (2014).
</p>
<p>
The construction of the borehole is non-conventional: the borehole is
contained within an aluminum pipe that acts as the borehole wall. As this
modifies the thermal resistances inside the borehole, the values evaluated by
the multipole method are modified to obtain the effective borehole thermal
resistance reported by Beier et al. (2011).
<h4>References</h4>
<p>
Beier, R.A., Smith, M.D. and Spitler, J.D. 2011. <i>Reference data sets for
vertical borehole ground heat exchanger models and thermal response test
analysis</i>. Geothermics 40: 79-85.
</p>
<p>
Pasquier, P., and Marcotte, D. 2014. <i>Joint use of quasi-3D response model and
spectral method to simulate borehole heat exchanger</i>. Geothermics 51:
281-299.
</p>
</html>", revisions="<html>
<ul>
<li>
April 8, 2021, by Michael Wetter:<br/>
Added missing <code>parameter</code> keyword.<br/>
For <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1464\">IBPSA, issue 1464</a>.
</li>
<li>
July 18, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})));
end Sandbox;
