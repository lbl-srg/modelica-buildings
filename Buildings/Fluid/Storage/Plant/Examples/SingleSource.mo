within Buildings.Fluid.Storage.Plant.Examples;
model SingleSource "Simple system model with one source and one user"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model for CDW";

  parameter Modelica.Units.SI.AbsolutePressure p_Pressurisation=300000
    "Pressurisation point";
  parameter Modelica.Units.SI.Power QCooLoa_flow_nominal=5*4200*0.1
    "Nominal cooling load of one consumer";

  Buildings.Fluid.Storage.Plant.Data.NominalValues nom(
    allowRemoteCharging=false,
    mTan_flow_nominal=0.5,
    mChi_flow_nominal=0.5,
    dp_nominal=300000,
    T_CHWS_nominal=280.15,
    T_CHWR_nominal=285.15) "Nominal values"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Fluid.Storage.Plant.TankBranch tanBra(
    preDro(final dp_nominal=nom.dp_nominal*0.1),
    redeclare final package Medium = Medium,
    final nom=nom) "Tank branch"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.ChillerBranch chiBra(
    redeclare final package Medium = Medium,
    final nom=nom) "Chiller branch"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,0})));
  Buildings.Fluid.Storage.Plant.NetworkConnection netCon(
    redeclare final package Medium = Medium,
    final nom=nom,
    allowRemoteCharging=nom.allowRemoteCharging,
    perPumSup(pressure(V_flow=nom.m_flow_nominal*{0,2}, dp=nom.dp_nominal*{2,0})))
    "Supply pump and valves that connect the plant to the district network"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

  Buildings.Fluid.Storage.Plant.Examples.BaseClasses.IdealUser ideUse(
    redeclare package Medium = Medium,
    m_flow_nominal=nom.m_flow_nominal,
    dp_nominal=0.3*nom.dp_nominal,
    T_a_nominal=nom.T_CHWS_nominal,
    T_b_nominal=nom.T_CHWR_nominal) "Ideal user"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Modelica.Blocks.Sources.TimeTable preQCooLoa_flow(table=[0*3600,0; 1200,0;
        1200,QCooLoa_flow_nominal; 2400,QCooLoa_flow_nominal; 2400,0; 1*3600,0])
    "Prescribed cooling load"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.Continuous.LimPID conPI_pumSec(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=1,
    Ti=100,
    reverseActing=true) "PI controller" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-10,50})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro1(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=nom.dp_nominal*0.3,
    final m_flow_nominal=nom.m_flow_nominal) "Flow resistance of the consumer"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro2(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=nom.dp_nominal*0.3,
    final m_flow_nominal=nom.m_flow_nominal) "Flow resistance of the consumer"
    annotation (Placement(transformation(extent={{30,-50},{10,-30}})));
  Modelica.Blocks.Sources.Constant set_dpUsr(k=1)
    "Normalised differential pressure setpoint of the user"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,90})));
  Buildings.Fluid.Sources.Boundary_pT sou_p(
    redeclare final package Medium = Medium,
    final p=p_Pressurisation,
    final T=nom.T_CHWR_nominal,
    nPorts=1) "Pressurisation point" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-70})));
  Modelica.Blocks.Math.Gain gaiPumSec(k=1/ideUse.dp_nominal) "Gain" annotation (
     Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,90})));
  Modelica.Blocks.Sources.Constant mSet_flow(k=nom.mChi_flow_nominal)
    "Chiller branch flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

equation
  connect(preQCooLoa_flow.y, ideUse.QCooLoa_flow) annotation (Line(points={{41,50},
          {66,50},{66,-9}},             color={0,0,127}));
  connect(preDro1.port_b, ideUse.port_a)
    annotation (Line(points={{30,-20},{60,-20}}, color={0,127,255}));
  connect(ideUse.port_b, preDro2.port_a) annotation (Line(points={{80,-20},{84,
          -20},{84,-40},{30,-40}}, color={0,127,255}));
  connect(set_dpUsr.y, conPI_pumSec.u_s)
    annotation (Line(points={{-10,79},{-10,70.5},{-10,70.5},{-10,62}},
                                                 color={0,0,127}));
  connect(ideUse.dpUse, gaiPumSec.u)
    annotation (Line(points={{78,-9},{78,90},{42,90}}, color={0,0,127}));
  connect(gaiPumSec.y, conPI_pumSec.u_m)
    annotation (Line(points={{19,90},{8,90},{8,50},{2,50}},
                                                          color={0,0,127}));
  connect(tanBra.port_bToChi, chiBra.port_a)
    annotation (Line(points={{-60,-6},{-70,-6}}, color={0,127,255}));
  connect(tanBra.port_aFroChi, chiBra.port_b)
    annotation (Line(points={{-60,6},{-70,6}}, color={0,127,255}));
  connect(mSet_flow.y, chiBra.mPumSet_flow)
    annotation (Line(points={{-79,-30},{-76,-30},{-76,-11}}, color={0,0,127}));
  connect(tanBra.port_aFroNet, netCon.port_bToChi)
    annotation (Line(points={{-40,-6},{-30,-6}}, color={0,127,255}));
  connect(tanBra.port_bToNet, netCon.port_aFroChi)
    annotation (Line(points={{-40,6},{-30,6}}, color={0,127,255}));
  connect(netCon.port_aFroNet, preDro2.port_b) annotation (Line(points={{-10,-6},
          {0,-6},{0,-40},{10,-40}}, color={0,127,255}));
  connect(netCon.port_bToNet, preDro1.port_a) annotation (Line(points={{-10,6},
          {4,6},{4,-20},{10,-20}}, color={0,127,255}));
  connect(conPI_pumSec.y,netCon. yPumSup) annotation (Line(points={{-10,39},{
          -10,16},{-22,16},{-22,11}},
                                  color={0,0,127}));
  connect(sou_p.ports[1], tanBra.port_aFroNet) annotation (Line(points={{-60,-70},
          {-34,-70},{-34,-6},{-40,-6}}, color={0,127,255}));
  annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Examples/SingleSource.mos"
        "Simulate and plot"),
experiment(Tolerance=1e-06, StopTime=3600), Documentation(info="<html>
<p>
This is a simple system model with only one source and one user.
The configuration of the storage plant is equivalent to having the tank in place of
the common pipe.
</p>
<p>
The primary and secondary pumps are controlled as such:
</p>
<ul>
<li>
The primary pump is set to a constant flow rate at all time.
</li>
<li>
The secondary pump is set to track the available head at the user.
</li>
</ul>
<p>
Under these settings, the tank is charged whenever the chiller outputs more than
needed by the user and discharges whenever the chiller outputs less than needed.
The capacity of the tank is not considered.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end SingleSource;
