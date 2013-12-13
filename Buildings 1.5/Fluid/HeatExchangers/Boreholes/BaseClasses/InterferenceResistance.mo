within Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses;
model InterferenceResistance
  "Total interference resistance between the two pipes of a borehole"
  extends
    Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.PartialBoreholeResistance;

  parameter Modelica.SIunits.Length xC
    "Shank spacing definied as half the center-to-center distance between the two pipes";

  parameter Modelica.SIunits.ThermalConductivity kSoi
    "Thermal conductivity of the soil used for the calculation of the internal interference resistance";

protected
  parameter Modelica.SIunits.ThermalResistance Ra=boreholeInternalResistance(
      hSeg=hSeg,
      rBor=rBor,
      rTub=rTub,
      eTub=eTub,
      xC=xC,
      kFil=kFil,
      kSoi=kSoi) "Borehole internal resistance";

equation
  if homotopyInitialization then
    Rb = homotopy(actual=boreholeThermalResistance(
            hSeg=hSeg, rBor=rBor, rTub=rTub, eTub=eTub, kTub=kTub,
            kFil=kFil, kMed=kMed, mueMed=mueMed, cpFluid=cpFluid, m_flow=m_flow,
            m_flow_nominal=m_flow_nominal, B0=B0, B1=B1),
         simplified=boreholeThermalResistance(
            hSeg=hSeg, rBor=rBor, rTub=rTub, eTub=eTub, kTub=kTub,
            kFil=kFil, kMed=kMed, mueMed=mueMed, cpFluid=cpFluid, m_flow=m_flow_nominal,
            m_flow_nominal=m_flow_nominal, B0=B0, B1=B1));
  else
   Rb = boreholeThermalResistance(
    hSeg=hSeg, rBor=rBor, rTub=rTub, eTub=eTub, kTub=kTub,
    kFil=kFil, kMed=kMed, mueMed=mueMed, cpFluid=cpFluid, m_flow=m_flow,
    m_flow_nominal=m_flow_nominal, B0=B0, B1=B1);
  end if;
  G = (4*Rb - Ra)/(4*Rb*Ra);
  annotation (
    Documentation(info="<html>
<p>
This model computes the interference resistance between the two pipes of a U-tube borehole. 
It computes the resistance using the 
internal resistance <i>R<sub>a</sub></i> and
the borehole total resistance <i>R<sub>b</sub></i>.
</p>
<p>
The coupling resistance is obtained using
</p>
<p align=\"center\" style=\"font-style:italic;\">
  R<sub>i</sub> = 4 R<sub>b</sub> R<sub>a</sub> &frasl; (4 R<sub>b</sub>- R<sub>a</sub>).
</p>
<h4>Implementation</h4>
<p>
The two resistances are calculated by the functions 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.boreholeThermalResistance\">
Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.boreholeThermalResistance</a> for <i>R<sub>b</sub></i> 
 and 
 <a href=\"modelica://Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.boreholeInternalResistance\">
Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.boreholeInternalResistance</a> for <i>R<sub>a</sub></i>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end InterferenceResistance;
