within Buildings.Fluid.Humidifiers.BaseClasses;
block PerformanceCurveModifier
  "Block for calculating modifier curves"

  parameter Buildings.Fluid.Humidifiers.Data.Generic per "Data record"
  annotation (Placement(transformation(extent={{22,64},{42,84}})));

  Modelica.Blocks.Interfaces.RealInput T "Temperature"
  annotation (Placement(transformation(
          extent={{-140,20},{-100,60}}), iconTransformation(extent={{-140,20},
            {-100,60}})));

  Modelica.Blocks.Interfaces.RealInput phi "Relative Humidity"
  annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealOutput watRemMod "Water removal modifier value"
  annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Interfaces.RealOutput eneFacMod "Energy factor modifier value"
  annotation (Placement(
        transformation(extent={{100,-50},{120,-30}}), iconTransformation(extent=
           {{100,-50},{120,-30}})));

equation
    //-------------------------Part-load performance modifiers----------------------------//
    // Compute the water removal and energy factor modifier fractions, using a biquadratic curve.
    // Since the regression for capacity can have negative values
    // (for unreasonable inputs), we constrain its return value to be
    // non-negative.
  watRemMod =Buildings.Utilities.Math.Functions.smoothMax(
      x1=Buildings.Utilities.Math.Functions.biquadratic(
        a=per.watRem,
        x1=Modelica.Units.Conversions.to_degC(T),
        x2=phi*100),
      x2=0.001,
      deltaX=0.0001);

  eneFacMod =Buildings.Utilities.Math.Functions.smoothMax(
        x1=Buildings.Utilities.Math.Functions.biquadratic(
          a=per.eneFac,
          x1=Modelica.Units.Conversions.to_degC(T),
          x2=phi*100),
        x2=0.001,
        deltaX=0.0001);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-149,-100},{151,-140}},
          textColor={0,0,255},
          textString="%name"), Rectangle(extent={{-100,100},{100,-100}},
            lineColor={0,0,127})}),                           Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4>Performance Curve Modifiers</h4>
<p>This block include the following performance curve modifiers</p>
<p>The water removal modifier curve <span style=\"font-family: Courier New;\">watRemMod</span> is a biquadratic curve with two independent variables: dry-bulb temperature and relative humidity of the air entering the dehumidifier. </p>
<p align=\"center\"><i>watRemMod(T<sub>in</sub>, phi<sub>in</sub>) = a<sub>1</sub> + a<sub>2</sub> T<sub>in</sub> + a<sub>3</sub> T<sub>in</sub> <sup>2</sup> + a<sub>4</sub> phi<sub>in</sub> + a<sub>5</sub> phi<sub>in</sub> <sup>2</sup> + a<sub>6</sub> T<sub>in</sub> phi<sub>in</i></sub> </p>
<p>The energy factor modifier curve <span style=\"font-family: Courier New;\">eneFacMod</span> is a biquadratic curve with two independent variables: dry-bulb temperature and relative humidity of the air entering the dehumidifier. </p>
<p align=\"center\"><i>eneFacMod(T<sub>in</sub>, phi<sub>in</sub>) = b<sub>1</sub> + b<sub>2</sub> T<sub>in</sub> + b<sub>3</sub> T<sub>in</sub> <sup>2</sup> + b<sub>4</sub> phi<sub>in</sub> + b<sub>5</sub> phi<sub>in</sub> <sup>2</sup> + b<sub>6</sub> T<sub>in</sub> phi<sub>in</i></sub> </p>
</html>", revisions="<html>
<ul>
<li>
Feburary 8, 2024, by Lingzhe Wang, Karthikeya Devaprasad, Xing Lu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PerformanceCurveModifier;
