within Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses;
model HexInternalElement "Internal part of a borehole"
  extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    T1_start=TFil_start,
    T2_start=TFil_start,
    final tau1=Modelica.Constants.pi*rTub^2*hSeg*rho1_nominal/m1_flow_nominal,
    final tau2=Modelica.Constants.pi*rTub^2*hSeg*rho2_nominal/m2_flow_nominal,
    final show_T=false,
    vol1(final energyDynamics=energyDynamics,
         final massDynamics=massDynamics,
         final prescribedHeatFlowRate=false,
         final homotopyInitialization=homotopyInitialization,
         final allowFlowReversal=allowFlowReversal1,
         final V=m2_flow_nominal*tau2/rho2_nominal,
         final m_flow_small=m1_flow_small),
    final vol2(final energyDynamics=energyDynamics,
         final massDynamics=massDynamics,
         final prescribedHeatFlowRate=false,
         final homotopyInitialization=homotopyInitialization,
         final V=m1_flow_nominal*tau1/rho1_nominal,
         final m_flow_small=m2_flow_small));

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (choicesAllMatching=true);

  replaceable parameter Buildings.HeatTransfer.Data.BoreholeFillings.Generic matFil
    "Thermal properties of the filling material"
    annotation (choicesAllMatching=true, Dialog(group="Filling material"),
                Placement(transformation(extent={{42,70},{62,90}})));

  parameter Modelica.SIunits.Radius rTub=0.02 "Radius of the tubes"
    annotation (Dialog(group="Pipes"));
  parameter Modelica.SIunits.ThermalConductivity kTub=0.5
    "Thermal conductivity of the tubes" annotation (Dialog(group="Pipes"));
  parameter Modelica.SIunits.Length eTub=0.002 "Thickness of the tubes"
    annotation (Dialog(group="Pipes"));
  parameter Modelica.SIunits.ThermalConductivity kSoi
    "Thermal conductivity of the soil used for the calculation of the internal interference resistance";

  parameter Modelica.SIunits.Temperature TFil_start=283.15
    "Initial temperature of the filling material"
    annotation (Dialog(group="Filling material"));

  parameter Modelica.SIunits.Radius rBor "Radius of the borehole";
  parameter Modelica.SIunits.Height hSeg "Height of the element";

  parameter Real B0=17.44268 "Shape coefficient for grout resistance";
  parameter Real B1=-0.60515 "Shape coefficient for grout resistance";

  parameter Modelica.SIunits.Length xC=0.05
    "Shank spacing definied as half the center-to-center distance between the two pipes";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port
    "Heat port that connects to filling material"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
protected
  final parameter Modelica.SIunits.SpecificHeatCapacity cpFil=matFil.c
    "Specific heat capacity of the filling material";
  final parameter Modelica.SIunits.ThermalConductivity kFil=matFil.k
    "Thermal conductivity of the filling material";
  final parameter Modelica.SIunits.Density dFil=matFil.d
    "Density of the filling material";
  parameter Modelica.SIunits.HeatCapacity Co_fil=0.5*dFil*cpFil*hSeg*Modelica.Constants.pi
      *(rBor^2 - 2*(rTub + eTub)^2) "Heat capacity of the filling material";
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor cap2(C=Co_fil, T(start=
         TFil_start)) "Heat capacity of the filling material" annotation (
      Placement(transformation(
        extent={{-90,-36},{-70,-16}},
        rotation=-90,
        origin={76,-140})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor cap1(C=Co_fil,T(start=
          TFil_start)) "Heat capacity of the filling material" annotation (
      Placement(transformation(
        extent={{-102,14},{-82,34}},
        rotation=0,
        origin={12,26})));
  BoreholeResistance con1(
    redeclare final package Medium = Medium,
    final rBor=rBor,
    final rTub=rTub,
    final eTub=eTub,
    final kTub=kTub,
    final kFil=kFil,
    final hSeg=hSeg,
    final B0=B0,
    final B1=B1,
    final m_flow_nominal=m1_flow_nominal,
    homotopyInitialization=homotopyInitialization)
    "Thermal resistance from the fluid to the wall of the borehole"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  BoreholeResistance con2(
    redeclare final package Medium = Medium,
    final rBor=rBor,
    final rTub=rTub,
    final eTub=eTub,
    final kTub=kTub,
    final kFil=kFil,
    final hSeg=hSeg,
    final B0=B0,
    final B1=B1,
    final m_flow_nominal=m1_flow_nominal,
    homotopyInitialization=homotopyInitialization)
    "Thermal resistance from the fluid to the wall of the borehole"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));

  InterferenceResistance con12(
    redeclare final package Medium = Medium,
    final rBor=rBor,
    final rTub=rTub,
    final eTub=eTub,
    final kTub=kTub,
    final kFil=kFil,
    final kSoi=kSoi,
    final hSeg=hSeg,
    final xC=xC,
    final B0=B0,
    final B1=B1,
    final m_flow_nominal=m1_flow_nominal,
    homotopyInitialization=homotopyInitialization)
    "Interference resistance between the two pipes" annotation (Placement(
        transformation(
        extent={{-74,-12},{-54,8}},
        rotation=-90,
        origin={-78,-74})));

  Modelica.Blocks.Sources.RealExpression m_flow(y=port_a1.m_flow)
    "Mass flow rate"
    annotation (Placement(transformation(extent={{-74,20},{-54,40}})));
equation
  connect(vol1.heatPort, cap1.port) annotation (Line(
      points={{-10,60},{-60,60},{-60,40},{-80,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol2.heatPort, cap2.port) annotation (Line(
      points={{12,-60},{40,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cap1.port, con12.port_a) annotation (Line(
      points={{-80,40},{-80,20},{-80,5.55112e-16},{-80,5.55112e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cap1.port, con1.port_a) annotation (Line(
      points={{-80,40},{-80,20},{-20,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con12.port_b, cap2.port) annotation (Line(
      points={{-80,-20},{-80,-40},{40,-40},{40,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con2.port_a, cap2.port) annotation (Line(
      points={{-20,-20},{-40,-20},{-40,-40},{40,-40},{40,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con1.port_b, port)   annotation (Line(
      points={{5.55112e-16,20},{60,20},{60,5.55112e-16},{100,5.55112e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(con2.port_b, port)   annotation (Line(
      points={{5.55112e-16,-20},{60,-20},{60,5.55112e-16},{100,5.55112e-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(m_flow.y, con1.m_flow) annotation (Line(
      points={{-53,30},{-40,30},{-40,26},{-22,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow.y, con2.m_flow) annotation (Line(
      points={{-53,30},{-40,30},{-40,-14},{-22,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow.y, con12.m_flow) annotation (Line(
      points={{-53,30},{-40,30},{-40,12},{-74,12},{-74,2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Icon(graphics={Rectangle(
          extent={{88,54},{-88,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid), Rectangle(
          extent={{88,-66},{-88,-56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Model for the heat transfer between the fluid and within the borehole filling.
This model computes the dynamic response of the fluid in the tubes, and the heat transfer between the
fluid and the borehole filling, and the heat storage within the fluid and the borehole filling.
</p>
<p>
The heat conduction in the filling material is modeled using three three resistances model that are
arranged in a triangular configuration. 
Two of these resistances represent the heat conduction from the fluids to the external radius of
the borehole, and the other resistance represents the thermal interference between the two pipes.
</p>
<p>
The resistance between the fluid and the borehole wall are the sum of the 
convective resistance inside the tubes, the conductive resistance
of the tube wall and the conductive resistance of the filling material. 
They are obtained using
 <p align=\"center\" style=\"font-style:italic;\">
 G<sub>Con</sub> = 2 &pi; h<sub>seg</sub> r<sub>tub</sub> h<sub>in</sub> , 
 </p>
<p align=\"center\" style=\"font-style:italic;\">
G<sub>tub</sub> = 4 &pi; k<sub>tub</sub> h<sub>seg</sub> &frasl; ln( ( r<sub>tub</sub>+e<sub>tub</sub> ) &frasl; r<sub>tub</sub> ),
</p>
<p align=\"center\" style=\"font-style:italic;\">
G<sub>fil</sub>= k<sub>fil</sub> h<sub>seg</sub> &beta;<sub>0</sub> ( r<sub>Bor</sub> &frasl; r<sub>tub</sub> ) <sup>&beta;<sub>1</sub></sup> ,
</p> 
where <i>h<sub>seg</sub></i> is the height of the tube, 
<i>h<sub>in</sub></i> is the convection coefficient,
<i>k<sub>tub</sub></i> is the thermal conductivity of the tube, 
<i>e<sub>tub</sub></i> is the thickness of the tube,
and <i>&beta;<sub>0</sub>, &beta;<sub>1</sub></i> are the resistance shape factor coefficients
(Paul, 1996).
Paul's shape factors are based on experimental and finite element analysis of typical borehole.
The default values used for these coefficients are &beta;<sub>0</sub>= 20.100 and &beta;<sub>1</sub>=-0.94467.
Values listed by Paul are given in the table below.
</p>
<p>
  <table>
  <tr><th>pipe spacing</th><th><i>&beta;<sub>0</sub></i></th><th><i>&beta;<sub>1</sub></i></th></tr>
  <tr><td> close  </td><td> 20.100377 </td><td> -0.94467 </td></tr>
  <tr><td> middle  </td><td> 17.44 </td><td> -0.6052  </td></tr>
  <tr><td> spaced </td><td> 21.91 </td><td> -0.3796 </td></tr>
  </table>
</p>
<h4>Implementation</h4>
<p>
The resistances between the fluid and the borehole wall are computed in
 <a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.BoreholeResistance\">
Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.BoreholeResistance</a>.
The resistance for the interference of the pipes is computed in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.InterferenceResistance\">
Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.InterferenceResistance</a>. 
</p>
</html>", revisions="<html>
<ul>
<li>
July 28 2011, by Pierre Vigouroux:<br>
First implementation.
</li>
</ul>
</html>"));
end HexInternalElement;
