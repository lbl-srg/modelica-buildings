within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial model PartialDXCoil
  "Partial model for DX CoilPartial model for Air cooled (or evaporative) cooled air-conditioner"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.EssentialParameters;
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare package Medium=Medium,
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol,
    final m_flow_nominal = datCoi.per[nSpe].nomVal.m_flow_nominal);
  extends Modelica.Icons.UnderConstruction;
  // redeclare Medium with a more restricting base class. This improves the error
  // message if a user selects a medium that does not contain the function
  // enthalpyOfLiquid(.)
  replaceable package Medium = Modelica.Media.Interfaces.PartialCondensingGases
      annotation (choicesAllMatching = true);
  Modelica.Blocks.Interfaces.RealInput TConIn(
    unit="K",
    displayUnit="degC")
    "Outside air dry bulb temperature for an air cooled condenser or wetbulb temperature for an evaporative cooled condenser"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Modelica.Blocks.Interfaces.RealOutput P
    "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,70},{120,90}},rotation=0)));

  Modelica.SIunits.SpecificEnthalpy hIn=
    if port_a.m_flow > 0 then inStream(port_a.h_outflow) else inStream(port_b.h_outflow)
    "Enthalpy of air entering the cooling coil";
  Modelica.SIunits.Temperature TIn = Medium.T_phX(p=port_a.p, h=hIn, X=XIn)
    "Dry bulb temperature of air entering the cooling coil";
  Modelica.SIunits.MassFraction XIn[Medium.nXi]=
    if port_a.m_flow > 0 then inStream(port_a.Xi_outflow) else inStream(port_b.Xi_outflow)
    "Mass fraction/absolute humidity of air entering the cooling coil";
  constant Integer iWat = 1 "Index of water component in XIn";

public
  BaseClasses.DXCooling dxCoo(
    redeclare package Medium = Medium,
    datCoi=datCoi,
    nSpe=nSpe) "DX cooling coil operation"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.RealExpression p(
    y=port_a.p) "Inlet air pressure"
    annotation (Placement(transformation(extent={{-90,4},{-70,24}})));
  Modelica.Blocks.Sources.RealExpression X(y=XIn[iWat])
    "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-56,26},{-36,46}})));
  Modelica.Blocks.Sources.RealExpression T(y=TIn) "Inlet air temperature"
    annotation (Placement(transformation(extent={{-90,18},{-70,38}})));
  Modelica.Blocks.Sources.RealExpression m(
    y=port_a.m_flow) "Inlet air mass flow rate"
    annotation (Placement(transformation(extent={{-90,34},{-70,54}})));
  Modelica.Blocks.Sources.RealExpression h(y=hIn) "Inlet air specific enthalpy"
    annotation (Placement(transformation(extent={{-56,12},{-36,32}})));

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow q "heat extracted by coil"
    annotation (Placement(transformation(extent={{62,50},{82,70}})));
  BaseClasses.InputPower pwr "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
equation
  connect(TConIn, dxCoo.TConIn)  annotation (Line(
      points={{-110,30},{-100,30},{-100,55},{-21,55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m.y, dxCoo.m_flow)  annotation (Line(
      points={{-69,44},{-66,44},{-66,52.4},{-21,52.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T.y, dxCoo.TIn)       annotation (Line(
      points={{-69,28},{-62,28},{-62,50},{-21,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p.y, dxCoo.p)  annotation (Line(
      points={{-69,14},{-58,14},{-58,47.6},{-21,47.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(X.y, dxCoo.XIn)      annotation (Line(
      points={{-35,36},{-30,36},{-30,45},{-21,45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(h.y, dxCoo.hIn)     annotation (Line(
      points={{-35,22},{-26,22},{-26,42.3},{-21,42.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxCoo.EIR, pwr.EIR)  annotation (Line(
      points={{1,58},{6,58},{6,76},{18,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxCoo.Q_flow, pwr.Q_flow)  annotation (Line(
      points={{1,54},{10,54},{10,70},{18,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxCoo.SHR, pwr.SHR)  annotation (Line(
      points={{1,50},{14,50},{14,64},{18,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxCoo.TCoilSurf, vol.TWat)  annotation (Line(
      points={{1,46},{10,46},{10,24},{-16,24},{-16,-14.8},{-11,-14.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxCoo.mWat_flow, vol.mWat_flow)  annotation (Line(
      points={{1,42},{6,42},{6,28},{-20,28},{-20,-18},{-11,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(q.port, vol.heatPort) annotation (Line(
      points={{82,60},{86,60},{86,20},{-12,20},{-12,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(pwr.P, P)    annotation (Line(
      points={{41,74},{50.5,74},{50.5,80},{110,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxCoo.Q_flow, q.Q_flow) annotation (Line(
      points={{1,54},{50,54},{50,60},{62,60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
              defaultComponentName="sSpeeDX", Diagram(graphics), Documentation(info="<html>
<p>
This partial model provides initial calculations for  
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.SingleSpeed\"> 
Buildings.Fluid.HeatExchangers.DXCoils.SingleSpeed</a>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.MultiSpeed\"> 
Buildings.Fluid.HeatExchangers.DXCoils.MultiSpeed\</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.VarSpeed\"> 
Buildings.Fluid.HeatExchangers.DXCoils.VarSpeed</a>.
</p>
<p>
An air (or evaporative) cooled direct expansion (DX) cooling coil can be modeled using this block. 
Apparatus Dew Point (ADP) / Bypass Factor (BF) method is used in this models which is explained in further discussion. <br>
To model an air cooled DX cooling coil use the outside dry-bulb temperature as input to TConIn (condenser coil inlet temperature) 
For DX coils with evaporative condenser cooling use wet-bulb temperature for TConIn. <br>
The model uses <a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolCap\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolCap</a> to calculate the current total cooling capacity
and energy input ratio (EIR) of the coil at the given conditions.
</p>
<p>
All performance data required for determination of cooling capacity, EIR and UA/Cp 
is entered in coil data. Coil data record for DX coils 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Data.CoilData\">
Buildings.Fluid.HeatExchangers.DXCoils.Data.CoilData</a> is used. <br>
Nominal unknown parameters are determined using 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.UACp\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.UACp</a> and 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.NominalCondition\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.NominalCondition</a> 
with the given nominal performance data. <br>
</p>
<h4>Nominal/Rated conditions</h4>
<p>
All nominal values (including sensible heat ratio, COP and mass flow rate) are entered in 
the performance record.
These values are measured at following conditions (EnergyPlus Engineering Reference, 2010):
<ul><li>
Dry bulb temperature of air entering cooling coil: 26.7 degC (~80 F)</li></ul>
<ul><li>
Wet bulb temperature of air entering cooling coil: 19.4 degC (~67 F) </li></ul>
<ul>
(At above condition relative humidity: 50%)</ul>
<ul><li>
Dry bulb temperature of air entering outdoor condenser coil: 35 degC (~95 F)</li></ul>
<ul><li>
Wet bulb temperature of air entering outdoor condenser coil: 23.9 degC (~75 F) </li></ul>
<ul><li>
Range for rated mass flow rate (per watt of total cooling capacity): 4.7*10<sup>-5</sup>  - 7.0*10<sup>-5</sup> kg/s </li></ul>
</p>
<h4>Model Description</h4>
<p>
Once total cooling capacity is calculated using 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolCap\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolCap</a>
it is divided into sensible and latent components using the ADP/BF method. 
The following figure explains ADP and BF:
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/DXCoils/BaseClasses/ApparatusDewPoint.png\" border=\"1\" width=\"507.2\" height=\"452.8\">
</p> 
The BF describes the fraction of air leaving the coil that is effectively at the same 
condition as the entering air and the remaining air leaves the coil at ADP condition 
(Kruis, 2010). Thus, BF is analogous to ineffectiveness (1 - &epsilon;)
in &epsilon;-NTU method. <br>
 
The value of UA/Cp is calculated at the initial state of the simulation. 
The same value is used for further time dependent calculations.
For a detailed discussion of how UA/Cp is calculated and its significance 
compared with the &epsilon;-NTU method refer to 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.UACp\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.UACp</a>. 
</p>
<p>
When UA/Cp is known, the bypass factor becomes a function of the current 
mass flow rate. For a calculated bypass factor and total cooling capacity with 
&phi; = 100% air properties at ADP are determined using 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDewPoint\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDewPoint</a> block. 
Since water is condensed at the coil, which is at the 
ADP condition, T<sub>ADP</sub> is the temperature at which water is removed from the coil.   

</p>
<p>
(Note: If X<sub>ADP</sub> &gt; X<sub>In</sub> then the coil surface is assumedn to be dry. 
In this case X<sub>In</sub> = X<sub>Out</sub> condition is used instead of &phi; = 100%.
For a detailed description of calculations for the dry coil surface refer to 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDryPoint\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDryPoint</a> and 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil</a>.) 
</p>
<p>
For wet coil surface similarity of triangles is used in above figure to determine 
SHR (sensible heat ratio). Refer 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.SensibleHeatRatio\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.SensibleHeatRatio</a> documentation. 
</p>
<p>
The calculated value of SHR is then used to determine the sensible cooling load. 
Latent cooling load is determined using the difference between total cooling load 
and sensible cooling load. Latent load is then used to calculate the amount of water 
condensed at the cooling coil. The rate at which water condenses at the coil is given 
as an input to 
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir\">
Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir</a> 
to determine the air condition at the outlet of the DX cooling coil.
</p>
<p>
Note: This model does not account for thermal effects and power consumption 
by indoor supply air fan. 
To model the an indoor supply air fan use a separate fan model.
</p>
<h4>References</h4>
<p>
<a href=\"http://www.energyplus.gov\">EnergyPlus 7.0 Engineering Reference</a>, May 24, 2012.
</p>
<p>
Kruis, Nathanael. <i>Reconciling differences between Residential DX Cooling Coil models in DOE-2 and EnergyPlus.</i> 
Forth National Conference of IBPSA-USA. New York: SimBuild, 2010. 134-141.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 4, 2012 by Michael Wetter:<br>
Moved assignments to declaration section to avoid mixing graphical modeling with textual
modeling in <code>equation</code> section.
Redeclare medium model as <code>Modelica.Media.Interfaces.PartialCondensingGases</code>
to remove errors during model check.
</li>
<li>
April 12, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"),
    Icon(graphics={Text(
          extent={{-158,58},{-100,40}},
          lineColor={0,0,255},
          textString="TConIn"), Text(
          extent={{92,108},{136,88}},
          lineColor={0,0,255},
          textString="P")}));
end PartialDXCoil;
