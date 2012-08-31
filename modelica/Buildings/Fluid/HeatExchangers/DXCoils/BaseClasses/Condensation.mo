within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
block Condensation "Calculates rate of condensation"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
     annotation (choicesAllMatching=true);
  Modelica.Blocks.Interfaces.RealInput TDewPoi(
    unit="K",
    displayUnit="degC") "Dew point temperature"
   annotation (Placement(transformation(extent={{-120,-70},{-100,-50}},rotation=0)));
  Modelica.Blocks.Interfaces.RealInput Q_flow(
    max=0,
    unit="W") "Heat flow"
     annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput SHR(
    min=0,
    max=1) "Sensible heat ratio"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Interfaces.RealOutput mWat_flow(
    quantity="MassFlowRate",
    unit="kg/s") "Mass flow rate of water condensed at cooling coil"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  output Modelica.SIunits.SpecificEnthalpy hLat(
    start=2500000,
    min=0) "Enthalpy of vaporization";
  output Modelica.SIunits.HeatFlowRate Q_flowLat(
    start=-10000,
    max=0) "Latent heat componenet of Q_flow";
equation
  Q_flowLat=(1-SHR)*Q_flow "Cooling capacity used for dehumidification";
  hLat=Medium.enthalpyOfVaporization(T=TDewPoi);
  mWat_flow*hLat=Q_flowLat;
annotation (defaultComponentName="conRat",
Documentation(info="<html>
<p>
The rate of condensation is calculated by this block. Latent heat component of cooling rate is claculated by
<p align=\"center\" style=\"font-style:italic;\">
  Q<sub>flowLat</sub> = (1-SHR)*Q<sub>flow</sub>
</p>
<p>
Then this latent heat is divided by heat of vaporization to calculate mass flow rate of condensate
</p>
<p align=\"center\" style=\"font-style:italic;\">
  mWat<sub>flow</sub> = Q<sub>flowLat</sub>/hLat</p>
<p></p>
</p>
</html>",
revisions="<html>
<ul>
<li>
August 9, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"),
        Icon(graphics={
          Ellipse(
          extent={{-40,16},{0,-24}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
          Polygon(
          points={{-20,60},{-40,0},{0,0},{-20,60}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
          Ellipse(
          extent={{4,-66},{16,-78}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
          Polygon(
          points={{10,-54},{4,-70},{16,-70},{10,-54}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
          Ellipse(
          extent={{44,-44},{64,-66}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
          Polygon(
          points={{54,-14},{44,-54},{64,-54},{54,-14}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}), Diagram(graphics));
end Condensation;
