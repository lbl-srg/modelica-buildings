within Buildings.ThermalZones.Detailed.Examples.FFD;
model NaturalConvectionWithControl
  "A case of natural convection with feedback loop control"
  extends Buildings.ThermalZones.Detailed.Examples.FFD.Tutorial.NaturalConvection(
      roo(
        nPorts=0,
        useCFD=true,
        samplePeriod=30,
        cfdFilNam = "modelica://Buildings/Resources/Data/Rooms/FFD/NaturalConvectionWithControl.ffd",
        massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial));

  HeatTransfer.Sources.PrescribedHeatFlow preHeatFlo
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.Continuous.LimPID conPID(
    yMin=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=120,
    k=1,
    yMax=2)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,50})));
  Modelica.Blocks.Sources.Constant TSet(k=275.15) "Temperature set point"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={90,50})));
equation
  connect(roo.yCFD[1], conPID.u_m) annotation (Line(
      points={{101,-26.5},{100,-26.5},{100,-26},{110,-26},{110,20},{50,20},{50,
          38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet.y, conPID.u_s) annotation (Line(
      points={{79,50},{62,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeatFlo.port, roo.heaPorAir) annotation (Line(
      points={{50,0},{76,0},{76,-38},{79,-38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conPID.y, preHeatFlo.Q_flow) annotation (Line(
      points={{39,50},{20,50},{20,0},{30,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},{
            220,120}})),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Examples/FFD/NaturalConvectionWithControl.mos"
        "Simulate and plot"),
   experiment(StopTime=60),
   Documentation(info="<html>
<p>
This model tests the coupled simulation of
<a href=\"modelica://Buildings.ThermalZones.Detailed.CFD\">
Buildings.ThermalZones.Detailed.CFD</a>
with the FFD program by simulating natural convection in an empty room with a PI controller and
a heater to maintain the temperature at room center to be <i>2</i>&circ;C.
</p>
<p>
The configuration of the simulation is the same as
<a href=\"modelica://Buildings.ThermalZones.Detailed.Examples.FFD.Tutorial.NaturalConvection\">
Buildings.ThermalZones.Detailed.Examples.FFD.Tutorial.NaturalConvection</a>, except that a heater with PI controller is added to maintain the desired room temperature.
</p>
<p>
The temperature at the central room is sent to the PI controller as measured temperature. Based on the difference of set temperature and measured temperaure PI
controller sends signal to the heater to yield the heat flow.
The heat flow is then injected into the room through the heat port as convective heat flow.
After receving the heat flow from Modelica, the FFD uniformly distributes it into the space.
</p>
<p>
Please note that<code> roo.yCFD[1]</code> is the temperature at the center of the room and <code> roo.yCFD[2]</code> is the velocity magnitude at the center of the room.
</p>
<p>
Figure (a) shows the velocity vectors and temperature contours in degree Celsius on the X-Z plane at <i>Y = 0.5</i> m as simulated by the FFD.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/ThermalZones/Detailed/Examples/FFD/NaturalConvectionWithControl.png\" border=\"1\"/>
</p>
<p align=\"center\">
Figure (a)
</p>
<p align=\"left\">
</html>", revisions="<html>
<ul>
<li>
July 7, 2015 by Michael Wetter:<br/>
Removed model for prescribed heat flow boundary condition
as the value was zero and hence the model is not needed.
This is for <a href=\"/https://github.com/lbl-srg/modelica-buildings/issues/439\">issue 439</a>.
</li>
<li>
July 25, 2014 by Wangda Zuo and Michael Wetter:<br/>
Removed the <code>initial equation</code> section as the assignment of
<code>roo.air.yCFD[1]</code> is done in the base class.
</li>
<li>
May 7, 2014, by Wei Tian:<br/>
First implementation.
</li>
</ul>
</html>"));
end NaturalConvectionWithControl;
