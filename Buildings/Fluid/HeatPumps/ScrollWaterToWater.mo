within Buildings.Fluid.HeatPumps;
model ScrollWaterToWater
  "Model for a scroll water to water heat pump"

  extends Buildings.Fluid.HeatPumps.BaseClasses.PartialWaterToWater(
    redeclare HeatPumps.Compressors.ScrollCompressor com(
      redeclare package ref = ref,
      volRat=datHeaPum.volRat,
      V_flow_nominal=datHeaPum.V_flow_nominal*scaling_factor,
      leaCoe=datHeaPum.leaCoe*scaling_factor,
      etaEle=datHeaPum.etaEle,
      PLos=datHeaPum.PLos*scaling_factor,
      dTSup=datHeaPum.dTSup),
    eva(UA=datHeaPum.UAEva*scaling_factor),
    con(UA=datHeaPum.UACon*scaling_factor));

  parameter Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic
    datHeaPum "Heat pump data" annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-98,78},{-78,98}})));

    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-100},{120,-80}})),
              defaultComponentName="heaPum",
    Documentation(info="<html>
<p>
Model for a water to water heat pump with a scroll compressor, as detailed 
in Jin (2002).
</p>
<h4>References</h4>
<p>
H. Jin.
<i>
Parameter estimation based models of water source heat pumps.
</i>
PhD Thesis. Oklahoma State University. Stillwater, Oklahoma, USA. 2012.
</p>
</html>", revisions="<html>
<ul>
<li>
November 11, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ScrollWaterToWater;
