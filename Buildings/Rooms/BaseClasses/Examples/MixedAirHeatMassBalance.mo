within Buildings.Rooms.BaseClasses.Examples;
model MixedAirHeatMassBalance "Test model for air heat and mass balance"
  extends Modelica.Icons.Example;
  extends
    Buildings.Rooms.BaseClasses.Examples.BaseClasses.PartialInfraredRadiation(
    nConExt=1, nConExtWin=0, nConBou=0, nSurBou=0, nConPar=0);
  package Medium = Buildings.Media.Air "Medium model";

  Buildings.Rooms.BaseClasses.MixedAirHeatMassBalance air(
    nConExt=nConExt,
    nConExtWin=nConExtWin,
    nConPar=nConPar,
    nConBou=nConBou,
    nSurBou=nSurBou,
    final datConExt=datConExt,
    final datConExtWin=datConExtWin,
    final datConPar=datConPar,
    final datConBou=datConBou,
    final surBou=surBou,
    m_flow_nominal=0.1,
    V=10,
    conMod=Buildings.HeatTransfer.Types.InteriorConvection.Fixed,
    hFixed=3,
    haveShade=datConExtWin[1].glaSys.haveShade,
    redeclare package Medium = Medium,
    nPorts=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Convective heat balance of air"
    annotation (Placement(transformation(extent={{-82,0},{-42,40}})));
protected
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conGlaSha[
    NConExtWin](each G=100) "Heat conductor"
    annotation (Placement(transformation(extent={{42,-182},{62,-162}})));
  Buildings.HeatTransfer.Sources.FixedTemperature bouConGlaSha[NConExtWin](
      each T=293.15) "Boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={92,-172})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conGlaUns[
    NConExtWin](each G=100) "Heat conductor"
    annotation (Placement(transformation(extent={{42,-142},{62,-122}})));
  Buildings.HeatTransfer.Sources.FixedTemperature bouConGlaUns[NConExtWin](
      each T=293.15) "Boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={92,-132})));
public
  Modelica.Blocks.Sources.Constant uSha[NConExtWin](each k=0)
    "Shade control signal"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
protected
  Buildings.Rooms.BaseClasses.MixedAirHeatGain heaGai(
    redeclare package Medium = Medium, final AFlo=5)
    "Model to convert internal heat gains"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
public
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-200,-30},{-180,-10}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Modelica.Blocks.Sources.Constant QRadAbs_flow[NConExtWin](each k=0)
    "Radiation absorbed by shade"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Buildings.Fluid.Sources.FixedBoundary
                              boundary(
    nPorts=1,
    redeclare package Medium = Medium,
    T=293.15) "Boundary condition"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
equation
  connect(conConExt.port_a, air.conExt)          annotation (Line(
      points={{40,90},{30,90},{30,38.3333},{-42,38.3333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConExtWin.port_a, air.conExtWin)          annotation (Line(
      points={{40,60},{30,60},{30,35},{-42,35}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConExtWinFra.port_a, air.conExtWinFra)          annotation (Line(
      points={{40,30},{30,30},{30,20},{-41.8333,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConPar_a.port_a, air.conPar_a)          annotation (Line(
      points={{40,0},{32,0},{32,15},{-41.8333,15}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConPar_b.port_a, air.conPar_b)          annotation (Line(
      points={{40,-30},{30,-30},{30,11.6667},{-41.8333,11.6667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conConBou.port_a, air.conBou)          annotation (Line(
      points={{40,-60},{28,-60},{28,6.66667},{-41.8333,6.66667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conSurBou.port_a, air.conSurBou)          annotation (Line(
      points={{40,-90},{24,-90},{24,1.66667},{-41.9167,1.66667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bouConGlaUns.port, conGlaUns.port_b) annotation (Line(
      points={{82,-132},{62,-132}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conGlaUns.port_a, air.glaUns) annotation (Line(
      points={{42,-132},{16,-132},{16,30},{-42,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(bouConGlaSha.port, conGlaSha.port_b) annotation (Line(
      points={{82,-172},{62,-172}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conGlaSha.port_a, air.glaSha) annotation (Line(
      points={{42,-172},{8,-172},{8,26.6667},{-42,26.6667}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(uSha.y, air.uSha) annotation (Line(
      points={{-119,90},{-90,90},{-90,36},{-84,36},{-84,36.6667},{-82.6667,
          36.6667}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaGai.QCon_flow, air.heaPorAir) annotation (Line(
      points={{-100,20},{-82,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaGai.QLat_flow, air.QLat_flow) annotation (Line(
      points={{-100,14},{-92,14},{-92,15},{-82,15}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(multiplex3_1.y, heaGai.qGai_flow) annotation (Line(
      points={{-139,20},{-122,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QRadAbs_flow.y, air.QRadAbs_flow) annotation (Line(
      points={{-119,50},{-94,50},{-94,28.3333},{-82.8333,28.3333}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(qRadGai_flow.y, multiplex3_1.u1[1]) annotation (Line(
      points={{-179,60},{-170,60},{-170,27},{-162,27}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y, multiplex3_1.u2[1]) annotation (Line(
      points={{-179,20},{-162,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qLatGai_flow.y, multiplex3_1.u3[1]) annotation (Line(
      points={{-179,-20},{-170,-20},{-170,13},{-162,13}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundary.ports[1], air.ports[1]) annotation (Line(
      points={{-100,-30},{-62,-30},{-62,0.166667}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,
            -200},{140,140}}),
                      graphics),
experiment(StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/BaseClasses/Examples/MixedAirHeatMassBalance.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Test model for the heat and mass balance of the room air.
</p>
</html>"));
end MixedAirHeatMassBalance;
