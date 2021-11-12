within Buildings.ThermalZones.Detailed;
model CFD
  "Model of a room in which the air is computed using Computational Fluid Dynamics (CFD)"
  extends Buildings.ThermalZones.Detailed.BaseClasses.PartialCFD(
  redeclare final BaseClasses.CFDAirHeatMassBalance air(
    final massDynamics = massDynamics,
    final cfdFilNam = absCfdFilNam,
    final useCFD=useCFD,
    final samplePeriod=samplePeriod,
    final haveSensor=haveSensor,
    final nSen=nSen,
    final sensorName=sensorName,
    final portName=portName,
    final uSha_fixed=uSha_fixed,
    final p_start=p_start,
    final haveSource=haveSource,
    final nSou=nSou,
    final sourceName=sourceName));
  annotation (
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,200}}),
                               graphics={Rectangle(
          extent={{-140,138},{140,78}},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Bitmap(
          extent={{-140,168},{150,-170}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/Detailed/cfd.png"),
        Text(
          extent={{162,98},{196,140}},
          lineColor={0,0,127},
          textString="yCFD"),
        Text(
          extent={{-86,-14},{0,16}},
          lineColor={0,0,0},
          textString="air"),
        Text(
          extent={{-102,-50},{-22,-26}},
          lineColor={0,0,0},
          textString="radiation"),
        Text(
          extent={{-114,-134},{-36,-116}},
          lineColor={0,0,0},
          textString="surface"),
        Text(
          extent={{-218,198},{-142,166}},
          lineColor={0,0,127},
          textString="s")}),
    Documentation(info="<html>
<p>
Room model that computes the room air flow using computational fluid dynamics (CFD). The CFD simulation is coupled to the thermal simulation of the room
and, through the fluid port, to the air conditioning system.
</p>
<p>
Currently, the supported CFD program is the
Fast Fluid Dynamics (FFD) program <a href=\"#ZUO2010\">(Zuo 2010)</a>.
See
<a href=\"modelica://Buildings.ThermalZones.Detailed.UsersGuide\">Buildings.ThermalZones.Detailed.UsersGuide</a>
for detailed explanations.
</p>
<h4>References</h4>
<p>
<a name=\"ZUO2010\"/>
Wangda Zuo. <a href=\"http://docs.lib.purdue.edu/dissertations/AAI3413824/\">
Advanced simulations of air distributions in buildings</a>.
Ph.D. Thesis, School of Mechanical Engineering, Purdue University, 2010.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 5, 2020, by Xu Han, Wei Tian, Cary Faulkner, Wangda Zuo and Michael Wetter:<br/>
Added interface for internal sources and changed strucuture in the modelica model. The FFD source codes has been updated, which 
includes new features to simulate data center airflow and thermal environment.
</li>
<li>
May 2, 2016, by Michael Wetter:<br/>
Refactored implementation of latent heat gain.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/515\">issue 515</a>.
</li>
<li>
April 21, 2016, by Michael Wetter:<br/>
Added parameter <code>absCfdFilNam</code> as the call to
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath\">
Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath</a>
was removed from
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.CFDExchange\">
Buildings.ThermalZones.Detailed.BaseClasses.CFDExchange</a>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">Buildings, #506</a>.
</li>
<li>
August 1, 2013, by Michael Wetter and Wangda Zuo:<br/>
First Implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-260,-220},{460,
            200}})));
end CFD;
