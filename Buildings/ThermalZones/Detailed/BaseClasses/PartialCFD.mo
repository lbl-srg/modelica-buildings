within Buildings.ThermalZones.Detailed.BaseClasses;
partial model PartialCFD
    "Model of a room in which the air is computed using Computational Fluid Dynamics (CFD)"
  extends Buildings.ThermalZones.Detailed.BaseClasses.RoomHeatMassBalance(
    redeclare replaceable BaseClasses.CFDAirHeatMassBalance air(
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

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics massDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));

  parameter Boolean useCFD = true
    "Set to false to deactivate the CFD computation and use instead yFixed as output"
    annotation(Dialog(group = "CFD"), Evaluate = true);
  parameter Modelica.Units.SI.Time samplePeriod(min=100*Modelica.Constants.eps)
    "Sample period of component"
    annotation(Dialog(group = "Sampling"));
  parameter Real uSha_fixed[nConExtWin] = zeros(nConExtWin)
    "Constant control signal for the shading device (0: unshaded; 1: fully shaded)";
  parameter String sensorName[:]
    "Names of sensors as declared in the CFD input file"
    annotation(Dialog(group = "CFD"));
  parameter String portName[nPorts] = {"port_" + String(i) for i in 1:nPorts}
    "Names of fluid ports as declared in the CFD input file"
    annotation(Dialog(group = "CFD"));
  parameter String cfdFilNam "CFD input file name"
    annotation (Dialog(group = "CFD",
        loadSelector(caption=
            "Select CFD input file")));
  parameter Integer nSou(min=0)
    "Number of sources that are connected to CFD input";
  parameter String sourceName[nSou]=fill("",nSou)
    "Names of sources as declared in the CFD input file";

  Modelica.Blocks.Interfaces.RealInput QIntSou[nSou](
    each unit="W") if haveSource
    "Internal source heat gain into room"
    annotation (Placement(transformation(extent={{-300,-130},{-260,-90}}),
        iconTransformation(extent={{-232,164},{-200,196}})));
  Modelica.Blocks.Interfaces.RealOutput yCFD[nSen]
    if haveSensor "Sensor for output from CFD"
    annotation (Placement(transformation(
     extent={{460,110},{480,130}}), iconTransformation(extent={{200,110},{220,130}})));

protected
  final parameter String absCfdFilNam = Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(cfdFilNam)
    "Absolute path to the CFD file";
  final parameter Boolean haveSource = nSou > 0
    "Flag, true if the model has at least one source";
  final parameter Boolean haveSensor = Modelica.Utilities.Strings.length(sensorName[1]) > 0
    "Flag, true if the model has at least one sensor";
  final parameter Integer nSen(min=0) = size(sensorName, 1)
    "Number of sensors that are connected to CFD output";

  Modelica.Blocks.Sources.Constant conSha[nConExtWin](final k=uSha_fixed)
    if haveShade "Constant signal for shade"
    annotation (Placement(transformation(extent={{-260,170},{-240,190}})));

equation
  connect(air.yCFD, yCFD) annotation (Line(
      points={{61,-142.5},{61,-206},{440,-206},{440,120},{470,120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conSha.y, conExtWin.uSha) annotation (Line(
      points={{-239,180},{328,180},{328,62},{281,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conSha.y, bouConExtWin.uSha) annotation (Line(
      points={{-239,180},{328,180},{328,64},{351,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conSha.y, conExtWinRad.uSha) annotation (Line(
      points={{-239,180},{420,180},{420,-42},{310.2,-42},{310.2,-25.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(irRadGai.uSha,conSha.y)
                             annotation (Line(
      points={{-100.833,-22.5},{-112,-22.5},{-112,180},{-239,180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conSha.y, radTem.uSha) annotation (Line(
      points={{-239,180},{-112,180},{-112,-62},{-100.833,-62},{-100.833,-62.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conSha.y, shaSig.u) annotation (Line(
      points={{-239,180},{-228,180},{-228,160},{-222,160}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(air.uSha,conSha.y)  annotation (Line(
      points={{39.6,-120},{28,-120},{28,180},{-239,180}},
      color={0,0,127},
      smooth=Smooth.None));

  // Connections to internal heat sources
  if haveSource then
    for i in 1:nSou loop
      connect(QIntSou[i], air.QIntSou[i]) annotation (Line(points={{-280,-110},{
              -212,-110},{-212,-202},{-18,-202},{-18,-140.9},{39,-140.9}},
                                            color={0,0,127}));
    end for;
  end if;

  annotation (
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,200}}),
                               graphics={Rectangle(
          extent={{-140,138},{140,78}},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{162,98},{196,140}},
          textColor={0,0,127},
          textString="yCFD"),
        Text(
          extent={{-86,-14},{0,16}},
          textColor={0,0,0},
          textString="air"),
        Text(
          extent={{-102,-50},{-22,-26}},
          textColor={0,0,0},
          textString="radiation"),
        Text(
          extent={{-114,-134},{-36,-116}},
          textColor={0,0,0},
          textString="surface"),
        Text(
          extent={{-218,198},{-142,166}},
          textColor={0,0,127},
          textString="s")}),
Documentation(info="<html>
<p>
Partial room model for detailed room model that computes the room air flow using
external solvers.
</p>
<p>
The simulation by external solvers is coupled to the thermal simulation of the room
and, through the fluid port, to the air conditioning system.
</p>
<p>
Currently, the supported external solvers are computational fluid dynamics (CFD)
and In Situ Adaptive Tabulation (ISAT).
See <a href=\"modelica://Buildings.ThermalZones.Detailed.UsersGuide\">
Buildings.ThermalZones.Detailed.UsersGuide</a> for detailed explanations.
</p>
<h4>References</h4>
<p>
<a name=\"ZUO2010\">W</a>angda Zuo.<br/>
<a href=\"http://docs.lib.purdue.edu/dissertations/AAI3413824/\">
Advanced simulations of air distributions in buildings</a>.<br/>
Ph.D. Thesis, School of Mechanical Engineering, Purdue University, 2010.
</p>
<p>
Wei Tian, Thomas Alonso Sevilla, Dan Li, Wangda Zuo, Michael Wetter.<br/>
<a href=\"https://www.tandfonline.com/doi/full/10.1080/19401493.2017.1288761\">
Fast and Self-Learning Indoor Airflow Simulation Based on In Situ Adaptive
Tabulation</a>.<br/>
Journal of Building Performance Simulation, 11(1), pp. 99-112, 2018.
</p>
<p>
Xu Han, Wei Tian, Wangda Zuo, Michael Wetter, James W. VanGilder.<br/>
<a href=\"https://www.researchgate.net/profile/Wangda_Zuo/publication/333797408_Optimization_of_Workload_Distribution_of_Data_Centers_Based_on_a_Self-Learning_In_Situ_Adaptive_Tabulation_Model/links/5d0467bf299bf12e7be02981/Optimization-of-Workload-Distribution-of-Data-Centers-Based-on-a-Self-Learning-In-Situ-Adaptive-Tabulation-Model.pdf\">
Optimization of Workload Distribution of Data Centers Based on a Self-Learning In
Situ Adaptive Tabulation Model</a>.<br/>
Proc. of the 16th Conference of International Building Performance Simulation
Association (Building Simulation 2019), Italy, September 2-4, Rome, 2019.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 1, 2019, by Xu Han, Wangda Zuo and Michael Wetter:<br/>
First Implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-260,-220},{460,
            200}})));
end PartialCFD;
