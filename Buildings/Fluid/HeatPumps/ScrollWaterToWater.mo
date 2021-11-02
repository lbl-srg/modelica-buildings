within Buildings.Fluid.HeatPumps;
model ScrollWaterToWater
  "Model for a scroll water to water heat pump"
  extends Buildings.Fluid.HeatPumps.BaseClasses.PartialWaterToWater(
    final UAEva=datHeaPum.UAEva*scaling_factor,
    final UACon=datHeaPum.UACon*scaling_factor,
    redeclare HeatPumps.Compressors.ScrollCompressor com(
      redeclare final package ref = ref,
      final volRat=datHeaPum.volRat,
      final V_flow_nominal=datHeaPum.V_flow_nominal*scaling_factor,
      final leaCoe=datHeaPum.leaCoe*scaling_factor,
      final etaEle=datHeaPum.etaEle,
      final PLos=datHeaPum.PLos*scaling_factor,
      final dTSup=datHeaPum.dTSup));

  parameter Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic datHeaPum
    "Heat pump data" annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-98,78},{-78,98}})));

    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-100},{120,-80}})),
              defaultComponentName="heaPum",
    Documentation(info="<html>
<p>
Model for a water to water heat pump with a scroll compressor, as described
in Jin (2002). The thermodynamic heat pump cycle is represented below.
</p>
<p align=\"center\">
<img  alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/HeatPumps/WaterToWater_Cycle.png\" border=\"1\"/>
</p>
<p>
The rate of heat transferred to the evaporator is given by:
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q&#775;<sub>Eva</sub> = m&#775;<sub>ref</sub> ( h<sub>Vap</sub>(T<sub>Eva</sub>) - h<sub>Liq</sub>(T<sub>Con</sub>) ).
</p>
<p>
The power consumed by the compressor is given by a linear efficiency relation:
</p>
<p align=\"center\" style=\"font-style:italic;\">
P = P<sub>Theoretical</sub> / &eta; + P<sub>Loss,constant</sub>.
</p>
<p>
Heat transfer in the evaporator and condenser is calculated using an
&epsilon;-NTU method, assuming constant refrigerant temperature and constant heat
transfer coefficient between fluid and refrigerant.
</p>
<p>
Variable speed is achieved by multiplying the full load suction volume flow rate
by the normalized compressor speed. The power and heat transfer rates are forced
to zero if the resulting heat pump state has higher evaporating pressure than
condensing pressure.
</p>
<p>
The model parameters are obtained by calibration of the heat pump model to
manufacturer performance data. Calibrated model parameters for various heat
pumps from different manufacturers are found in
<a href=\"modelica://Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater\">
Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater</a>. The calibrated model is
located in
<a href=\"modelica://Buildings.Fluid.HeatPumps.Calibration.ScrollWaterToWater\">
Buildings.Fluid.HeatPumps.Calibration.ScrollWaterToWater</a>.
</p>
<h4>Options</h4>
<p>
Parameters <code>TConMax</code> and <code>TEvaMin</code>
may be used to set an upper or lower bound for the
condenser and evaporator.
The compressor is disabled when these conditions
are not satisfied, or when the
evaporator temperature is larger
than the condenser temperature.
This mimics the temperature protection
of heat pumps and moreover it avoids
non-converging algebraic loops of equations,
or freezing of evaporator medium.
This option can be disabled by setting
<code>enable_temperature_protection = false</code>.
</p>
<h4>Assumptions and limitations</h4>
<p>
The compression process is assumed isentropic. The thermal energy
of superheating is ignored in the evaluation of the heat transferred to the refrigerant
in the evaporator. There is no supercooling.
</p>
<h4>References</h4>
<p>
H. Jin.
<i>
Parameter estimation based models of water source heat pumps.
</i>
PhD Thesis. Oklahoma State University. Stillwater, Oklahoma, USA. 2002.
</p>
</html>", revisions="<html>
<ul>
<li>
May 30, 2017, by Filip Jorissen:<br/>
Revised documentation for temperature protection.
See <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/769\">#769</a>.
</li>
<li>
November 11, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ScrollWaterToWater;
