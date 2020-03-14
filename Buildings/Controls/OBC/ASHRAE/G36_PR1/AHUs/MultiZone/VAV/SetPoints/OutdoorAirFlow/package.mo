within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints;
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
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone</a>
conducts zone level calculations for specifying minimum outdoor airflow rate,
</li>
<li> 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.System\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.System</a>
conducts system level calculations for specifying minimum outdoor airflow rate,
</li>
<li> 
and <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone</a>
finds the sums, the maximum and the minimum of outputs from zone level calculations.
They become inputs of system level calculation.
</li>
</ul>
<p>
The calculation is done using the steps below.
</p>
<ol>
<li>
<p>
Compute the required breathing zone outdoor airflow using the following components.
</p>
<ul>
<li>The area component of the breathing zone outdoor airflow.
</li>
<li>The population component of the breathing zone outdoor airflow.
</li>
</ul>
<p>
The number of occupant in each zone can be retrieved directly from occupancy sensor
if the sensor exists, or using the default occupant density and multiplying it with
zone area. The occupant density can be found from Table 6.2.2.1 in ASHRAE Standard
62.1-2013. For design purpose, use the design zone population to determine
the minimum requirement at the ventilation-design condition.
</p>
</li>
<li>
<p>
Compute the zone air-distribution effectiveness <code>zonDisEff</code>.
Table 6.2.2.2 in ASHRAE 62.1-2013 lists some typical values for setting the
effectiveness. Depending on difference between zone space temperature
<code>TZon</code> and discharge air temperature (after the reheat coil) <code>TDis</code>, Warm-air
effectiveness <code>zonDisEffHea</code> or Cool-air effectiveness
<code>zonDisEffCoo</code> should be applied.
</p>
</li>
<li>
<p>
Compute the required zone outdoor airflow <code>zonOutAirRate</code>.
For each zone in any mode other than occupied mode and for zones that have
window switches and the window is open, set <code>zonOutAirRate = 0</code>.
Otherwise, the required zone outdoor airflow <code>zonOutAirRate</code>
shall be calculated as follows:
</p>
<ul>
<li>
If the zone is populated, or if there is no occupancy sensor:
<ul>
<li>
If the discharge air temperature at the terminal unit is less than or equal to
the zone space temperature, set <code>zonOutAirRate = (breZonAre+breZonPop)/disEffCoo</code>.
</li>
<li>
If the discharge air temperature at the terminal unit is greater than zone space
temperature, set <code>zonOutAirRate = (breZonAre+breZonPop)/disEffHea</code>.
</li>
</ul>
</li>
<li>
If the zone has an occupancy sensor and is unpopulated:
<ul>
<li>
If the discharge air temperature at the terminal unit is less than or equal to
the zone space temperature, set <code>zonOutAirRate = breZonAre/disEffCoo</code>.
</li>
<li>
If the discharge air temperature at the terminal unit is greater than zone
space temperature, set <code>zonOutAirRate = breZonAre/disEffHea</code>.
</li>
</ul>
</li>
</ul>
</li>

<li>
<p>
Compute the outdoor air fraction for each zone <code>priOutAirFra</code> as follows.
Set the zone outdoor air fraction to
</p>
<pre>
    priOutAirFra = zonOutAirRate/VDis_flow
</pre>
<p>
where, <code>VDis_flow</code> is the measured discharge air flow rate from the zone VAV box.
For design purpose, the design zone outdoor air fraction <code>desZonPriOutAirRate</code>
is
</p>
<pre>
    desZonPriOutAirRate = desZonOutAirRate/minumZonFlo
</pre>
<p>
where <code>minumZonFlo</code> is the minimum expected zone primary flow rate and
<code>desZonOutAirRate</code> is the required design zone outdoor airflow rate.
</p>
</li>
<li>
<p>
Compute the occupancy diversity fraction <code>occDivFra</code>.
During system operation, the system population equals the sum of the zone population,
so <code>occDivFra=1</code>. It has no impact on the calculation of the uncorrected
outdoor airflow <code>sysUncOutAir</code>.
For design purpose, compute for all zones
</p>
<pre>
    occDivFra = peaSysPopulation/sum(desZonPopulation)
</pre>
<p>
where
<code>peaSysPopulation</code> is the peak system population and
<code>desZonPopulation</code> is the sum of the design population.
</p>
</li>
<li>
<p>
Compute the uncorrected outdoor airflow rate <code>unCorOutAirInk</code>,
<code>sysUncOutAir</code> as
</p>
<pre>
    unCorOutAirInk = occDivFra*sum(breZonPop)+sum(breZonAre).
</pre>
</li>
<li>
<p>
Compute the system primary airflow <code>sysPriAirRate</code>,
which is equal to the sum of the discharge airflow rate measured
from each VAV box <code>VDis_flow</code>.
For design purpose, a highest expected system primary airflow <code>VPriSysMax_flow</code>
should be applied. It usually is estimated with a load-diversity factor of <i>0.7</i>. (Stanke, 2010)
</p>
</li>
<li>
<p>
Compute the outdoor air fraction as
</p>
<pre>
    outAirFra = sysUncOutAir/sysPriAirRate.
</pre>
<p>
For design purpose, use
</p>
<pre>
    aveOutAirFra = unCorOutAirInk/VPriSysMax_flow.
</pre>
</li>
<li>
<p>
Compute the zone ventilation efficiency <code>zonVenEff</code>, for design purpose, as
</p>
<pre>
    zonVenEff[i] = 1 + aveOutAirFra - desZonPriOutAirRate[i]
</pre>
<p>
where the <code>desZonPriOutAirRate</code> is the design zone outdoor airflow fraction.
</p>
</li>
<li>
<p>
Compute the system ventilation efficiency.
During system operation, the system ventilation efficiency <code>sysVenEff</code> is
</p>
<pre>
    sysVenEff = 1 + outAirFra - max(priOutAirFra[i])
</pre>
<p>
The design system ventilation efficiency <code>desSysVenEff</code> is
</p>
<pre>
    desSysVenEff = min(zonVenEff[i]).
</pre>
</li>
<li>
<p>
Compute the minimum required system outdoor air intake flow rate.
The minimum required system outdoor air intake flow should be the uncorrected
outdoor air intake <code>sysUncOutAir</code> divided by the system ventilation
efficiency <code>sysVenEff</code>, but it should not be larger than the design
outdoor air rate <code>desOutAirInt</code>. Hence,
</p>
<pre>
    effMinOutAirInt = min(sysUncOutAir/sysVenEff, desOutAirInt),
</pre>
<p>
where the design outdoor air rate <code>desOutAirInt</code> is
</p>
<pre>
    desOutAirInt = unCorOutAirInk/desSysVenEff.
</pre>
</li>
</ol>

<h4>References</h4>
<p>
ANSI/ASHRAE Standard 62.1-2013,
<i>Ventilation for Acceptable Indoor Air Quality.</i>
</p>
<p>
Stanke, D., 2010. <i>Dynamic Reset for Multiple-Zone Systems.</i> ASHRAE Journal, March
2010.
</p>
</html>", revisions="<html>
<ul>
<li>
March 13, 2020, by Jianjun Hu:<br/>
Reimplemented sequence of calculating the outdoor airflow setpoint to separated
vector related calculation. This therefore breaks the single sequence to three
subsequences.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1829\">#1829</a>.
</li>
<li>
July 23, 2019, by Michael Wetter:<br/>
Improved documentation.
</li>
</ul>
</html>"));
end OutdoorAirFlow;
