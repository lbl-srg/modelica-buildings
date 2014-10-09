within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
partial block PartialSurfaceCondition
  "Partial block for apparatus dew and dry point calculation"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
     annotation (choicesAllMatching=true);
  replaceable parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData   datHP
    "Performance data";
//protected
  parameter Integer nSta=datHP.nCooSta "Number of stages";
  constant Boolean variableSpeedCoil "Flag, set to true to interpolate data";

  parameter Modelica.SIunits.MassFlowRate m_flow_small = datHP.m1_flow_small
    "Small mass flow rate for the evaporator, used for regularization";
  final parameter Modelica.SIunits.AngularVelocity maxSpe(displayUnit="1/min")= datHP.cooSta[nSta].spe
    "Maximum rotational speed";
  Modelica.Blocks.Interfaces.RealInput speRat "Speed index"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}}, rotation=
            0)));
  Modelica.Blocks.Interfaces.RealInput Q_flow(
    quantity="Power",
    unit="W") "Cooling capacity of the coil"
   annotation (Placement(transformation(extent={{-120,29},{-100,49}})));
  Modelica.Blocks.Interfaces.RealInput m_flow(
    quantity="MassFlowRate",
    unit="kg/s") "Air mass flow rate"
   annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput p(
    quantity="Pressure",
    unit="Pa") "Air static pressure"
  annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Modelica.Blocks.Interfaces.RealInput XIn "Inlet air mass fraction"
  annotation (Placement(transformation(extent={{-120,-60},{-100,-40}},
                                                                    rotation=
            0)));                         //(start=0.005, min=0, max=1.0)
  Modelica.Blocks.Interfaces.RealInput hIn(
    quantity="SpecificEnergy",
    unit="J/kg") "Air inlet specific enthalpy"
  annotation (Placement(transformation(extent={{-120,-90},{-100,-70}},rotation=
            0)));
  output Real bypass(
    start=0.25,
    min=0,
    max=1.0) "Bypass factor";
  output Modelica.SIunits.AngularVelocity spe(displayUnit="1/min")
    "Rotational speed";

  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.UACp uacp[nSta](
    redeclare final package Medium = Medium,
    TIn_nominal=datHP.cooSta.nomVal.T1In_nominal,
    p_nominal=datHP.cooSta.nomVal.p1_nominal,
    phiIn_nominal=datHP.cooSta.nomVal.phi1In_nominal,
    Q_flow_nominal=datHP.cooSta.nomVal.Q_flow_nominal,
    m_flow_nominal=datHP.cooSta.nomVal.m1_flow_nominal,
    SHR_nominal=datHP.cooSta.nomVal.SHR_nominal) "Calculates UA/Cp of the coil"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

//protected
  output Modelica.SIunits.MassFlowRate m_flow_nonzero
    "Evaporator air mass flow rate, bounded away from zero";
  output Modelica.SIunits.SpecificEnthalpy delta_h(
    start=40000,
    min=0.0)
    "Enthalpy required to be removed from the inlet air to attain apparatus dry point condition";
  output Real UAcp(
    min=0,
    fixed=false) "UA/Cp of coil";

public
  Modelica.Blocks.Interfaces.IntegerInput mode "Mode of operation"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}}),
        iconTransformation(extent={{-120,90},{-100,110}})));
algorithm
  if not variableSpeedCoil and mode == 0 then
    m_flow_nonzero := 0;
    UAcp           := 0;
    bypass         := 0;
    delta_h        := 0;
  else
    // Small mass flow rate to avoid division by zero
    m_flow_nonzero := Buildings.Utilities.Math.Functions.smoothMax(
      x1=m_flow,
      x2=m_flow_small,
      deltaX=0.1*m_flow_small);
    spe:=speRat*maxSpe;

    if variableSpeedCoil then
      UAcp := Buildings.Utilities.Math.Functions.smoothMax(
         x1=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions.speedShift(
           spe=spe,
           speSet={datHP.cooSta[iSpe].spe for iSpe in 1:nSta},
           u={uacp[iSpe].UAcp for iSpe in 1:nSta}),
         x2=uacp[nSta].UAcp/1E3,
         deltaX=uacp[nSta].UAcp/1E4);
     else
      UAcp := uacp[1].UAcp;//UAcp := uacp[stage].UAcp;
        // This stage varible is been replaced by 1 because in the het pump model
        // stage is been replaced by mode and in single speed cooling mode is represented by
        // mode = 2
     end if;

    bypass := Buildings.Utilities.Math.Functions.smoothLimit(
      x=  Modelica.Math.exp(-UAcp / m_flow_nonzero),
      l=  0.01,
      u=  0.99,
      deltaX=  0.001);
   delta_h:=Buildings.Utilities.Math.Functions.smoothMin(
      x1=-Q_flow/m_flow_nonzero/(1 - bypass),
      x2=0.999*hIn,
      deltaX=0.0001);
 /*   delta_h := -Q_flow / m_flow_nonzero / (1 - bypass);
 */
    end if;
  annotation (Documentation(info="<html>
<p>
This partial block is the base class for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDewPoint\"> 
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDewPoint</a> and
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDryPoint\"> 
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDryPoint</a>.
</p>
<p>
This block calculates the <i>UA/c<sub>p</sub></i> value, the bypass factor and the
enthalpy difference across the coil.
It uses the function
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions.speedShift\"> 
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions.speedShift</a>
for intermediate compressor speeds.
</i>
</p>
<h4>Implementation</h4>
<p>
For coils that only have discrete compressor speeds, this block does not do an interpolation
for intermediate speeds.
For coils with variable speed compressors, the computations are also done if the coil is off,
as this ensures that the derivatives are continuous near the off conditions.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 24, 2012 by Michael Wetter:<br>
Revised implementation.
</li>
<li>
August 24, 2012, by Michael Wetter:<br>
Moved function from 
<code>Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses</code>
to 
<code>Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Functions</code>
because the package 
<code>Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses</code>
already contains a block called 
<code>SpeedShift</code> which gives a clash in file names on file systems
that do not distinguish between upper and lower case letters.
</li>
<li>
August 1, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"), Icon(graphics),
    Diagram(graphics));
end PartialSurfaceCondition;
