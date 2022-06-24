within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints;
package OutdoorAirFlow "Package of sequences for calculating minimum outdoor airflow rate"
annotation (
Documentation(info="<html>
<p>
This package contains sequences to set the minimum outdoor airflow setpoint for 
compliance with the ventilation rate procedure of ASHRAE 62.1-2013. The
implementation is according to ASHRAE Guidline 36 (G36), PART 5.N.3.a, PART 5.B.2.b,
PART3.1-D.2.a.
</p>
<ul>
<li> 
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone</a>
conducts zone level calculations for specifying minimum outdoor airflow rate,
</li>
<li> 
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.AHU\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.AHU</a>
conducts AHU level calculations for specifying minimum outdoor airflow rate,
</li>
<li> 
and <a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone</a>
finds the sums, the maximum and the minimum of outputs from zone level calculations.
They become inputs of AHU level calculation.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
March 13, 2020, by Jianjun Hu:<br/>
Reimplemented sequence of calculating the outdoor airflow setpoint to separated
vector-valued calculation. This therefore breaks the single sequence to three
subsequences.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1829\">#1829</a>.
</li>
<li>
July 23, 2019, by Michael Wetter:<br/>
Improved documentation.
</li>
</ul>
</html>"), Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Ellipse(
          origin={10,10},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-80.0,0.0},{-20.0,60.0}}),
        Ellipse(
          origin={10,10},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,0.0},{60.0,60.0}}),
        Ellipse(
          origin={10,10},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,-80.0},{60.0,-20.0}}),
        Ellipse(
          origin={10,10},
          fillColor={76,76,76},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-80.0,-80.0},{-20.0,-20.0}})}));
end OutdoorAirFlow;
