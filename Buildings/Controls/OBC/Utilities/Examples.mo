within Buildings.Controls.OBC.Utilities;
package Examples
  extends Modelica.Icons.ExamplesPackage;

  model OptimalStart
    extends Modelica.Icons.Example;
    replaceable package Medium = Buildings.Media.Air
      "Medium model";
    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHea(k=21 + 273.15)
      annotation (Placement(transformation(extent={{-136,40},{-116,60}})));
    Buildings.Controls.OBC.Utilities.OptimalStart optStaHea(heating_only=true,
        cooling_only=false) "Heating only case"
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
    Buildings.Fluid.MixingVolumes.MixingVolume rooVol(
      redeclare package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      T_start=293.15,
      m_flow_nominal=1,
      V=50*30*3) "Volume of air in the room" annotation (Placement(
          transformation(extent={{117,16},{137,36}})));
    Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TAir
      "Room air temperature"
      annotation (Placement(transformation(extent={{36,-4},{16,16}})));
    Buildings.Controls.OBC.CDL.Continuous.Add add1(final k1=-1, final k2=+1)
      "Calculate differential between time-to-next-occupancy and the cool-down time"
      annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
      pre_y_start=false,
      uHigh=0,
      uLow=-60)
      "Hysteresis to activate the cool-down model"
      annotation (Placement(transformation(extent={{-30,40},{-10,60}})));
    SetPoints.OccupancySchedule occSch(occupancy=3600*{8,18})
      "Occupancy schedule"
      annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
    Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
      annotation (Placement(transformation(extent={{0,40},{20,60}})));
    Modelica.Blocks.Math.Gain PHea(k=700)
      annotation (Placement(transformation(extent={{40,40},{60,60}})));
    HeatTransfer.Sources.PrescribedHeatFlow QHea
      annotation (Placement(transformation(extent={{82,40},{102,60}})));
    CDL.Continuous.Sources.Sine DelT(
      amplitude=-2,
      freqHz=1/100000,
      startTime(displayUnit="h"))     "Zone temperature for heating case"
      annotation (Placement(transformation(extent={{0,74},{20,94}})));
    HeatTransfer.Sources.PrescribedHeatFlow QLos
      annotation (Placement(transformation(extent={{82,74},{102,94}})));
    Modelica.Blocks.Math.Gain UA(k=200)
      annotation (Placement(transformation(extent={{40,74},{60,94}})));
  equation
    connect(TAir.port,rooVol. heatPort) annotation (Line(points={{36,6},{106,6},
            {106,26},{117,26}},color={191,0,0}));
    connect(TAir.T, optStaHea.TZon) annotation (Line(points={{16,6},{-110,6},{
            -110,30},{-102,30}},
                            color={0,0,127}));
    connect(occSch.tNexOcc, add1.u1) annotation (Line(points={{-79,76},{-66,76},
            {-66,56},{-62,56}},
                           color={0,0,127}));
    connect(optStaHea.tOpt, add1.u2) annotation (Line(points={{-78,34},{-66,34},
            {-66,44},{-62,44}},
                           color={0,0,127}));
    connect(add1.y, hys1.u) annotation (Line(points={{-38,50},{-32,50}}, color={0,0,127}));
    connect(hys1.y, booToRea.u)  annotation (Line(points={{-8,50},{-2,50}}, color={255,0,255}));
    connect(TSetHea.y, optStaHea.TSetZonHea) annotation (Line(points={{-114,50},
            {-110,50},{-110,38},{-102,38}},
                                      color={0,0,127}));
    connect(booToRea.y,PHea. u)  annotation (Line(points={{22,50},{38,50}}, color={0,0,127}));
    connect(PHea.y, QHea.Q_flow)  annotation (Line(points={{61,50},{82,50}}, color={0,0,127}));
    connect(QHea.port, rooVol.heatPort) annotation (Line(points={{102,50},{106,
            50},{106,26},{117,26}},
                              color={191,0,0}));
    connect(DelT.y, UA.u)
      annotation (Line(points={{22,84},{38,84}}, color={0,0,127}));
    connect(UA.y, QLos.Q_flow)
      annotation (Line(points={{61,84},{82,84}}, color={0,0,127}));
    connect(QLos.port, rooVol.heatPort) annotation (Line(points={{102,84},{106,
            84},{106,26},{117,26}}, color={191,0,0}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
      experiment(StopTime=604800));
  end OptimalStart;

  model OptimalStartVAV
    extends Modelica.Icons.Example;
    extends Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.PartialOpenLoop(weaDat(filNam=
            ModelicaServices.ExternalReferences.loadResource(
            "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")));
    parameter Modelica.SIunits.Temperature TSupChi_nominal=279.15
      "Design value for chiller leaving water temperature";
    Buildings.Controls.OBC.Utilities.Examples.BaseClasses.Controller controller(
      controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
      kCoo=1,
      yHeaMax=0.2,
      AFlo=48,
      VOutMin_flow=0.0144,
      VOutDes_flow=0.025,
      yMin=0.1,
      kHea=4,
      kMod=4,
      have_occSen=false,
      TZonHeaOff=288.15,
      TZonCooOn=298.15,
      TSupSetMax=323.15,
      TSupSetMin=285.15)
      "VAV controller"
      annotation (Placement(transformation(extent={{-120,-28},{-80,20}})));
    Controls.OBC.CDL.Continuous.Hysteresis hysChiPla(
      uLow=-1,
      uHigh=0)
      "Hysteresis with delay to switch on cooling"
      annotation (Placement(transformation(extent={{-72,-120},{-52,-100}})));
    Modelica.Blocks.Math.Feedback errTRooCoo
      "Control error on room temperature for cooling"
      annotation (Placement(transformation(extent={{-110,-120},{-90,-100}})));
    Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{8,18})
      "Occupancy schedule"
      annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
    Modelica.Blocks.Sources.BooleanConstant uWin(k=false) "Window opening signal"
      annotation (Placement(transformation(extent={{-180,-60},{-160,-40}})));
    Modelica.Blocks.Math.BooleanToReal occPer "Conversion to number of occupants"
      annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));
    Modelica.Blocks.Math.Gain ppl(k=2) "Gain for number of occupants"
      annotation (Placement(transformation(extent={{-154,-86},{-142,-74}})));
  protected
    Modelica.Blocks.Sources.Constant TSetSupChiConst(final k=TSupChi_nominal)
      "Set point for chiller temperature"
      annotation (Placement(transformation(extent={{-72,-80},{-52,-60}})));
  equation
    connect(controller.yFan, hvac.uFan) annotation (Line(points={{-79,7.07692},{
            -62,7.07692},{-62,18},{-42,18}},
                                color={0,0,127}));
    connect(controller.yHeaCoi, hvac.uHea) annotation (Line(points={{-79,-9.35385},
            {-60,-9.35385},{-60,12},{-42,12}},
                                color={0,0,127}));
    connect(controller.yOutDamPos, hvac.uEco) annotation (Line(points={{-79,
            -19.6923},{-56,-19.6923},{-56,-2},{-42,-2}},
                                   color={0,0,127}));
    connect(TSetSupChiConst.y, hvac.TSetChi) annotation (Line(points={{-51,-70},{
            -46,-70},{-46,-16},{-42,-16},{-42,-15}},
                                       color={0,0,127}));
    connect(errTRooCoo.y, hysChiPla.u)
      annotation (Line(points={{-91,-110},{-74,-110}}, color={0,0,127}));
    connect(zon.TRooAir, errTRooCoo.u1) annotation (Line(points={{81,0},{110,0},{
            110,-152},{-134,-152},{-134,-110},{-108,-110}}, color={0,0,127}));
    connect(hysChiPla.y, hvac.chiOn) annotation (Line(points={{-50,-110},{-48,-110},
            {-48,-10},{-42,-10}},       color={255,0,255}));
    connect(weaBus.TDryBul, controller.TOut) annotation (Line(
        points={{-30,80},{-30,60},{-140,60},{-140,18.1538},{-122,18.1538}},
        color={255,204,51},
        thickness=0.5), Text(
        textString="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(zon.TRooAir, controller.TZon) annotation (Line(points={{81,0},{110,
            0},{110,-152},{-134,-152},{-134,10.7692},{-122,10.7692}},
                                                         color={0,0,127}));
    connect(hvac.TSup, controller.TSup) annotation (Line(points={{1,-8},{10,-8},{
            10,-50},{-130,-50},{-130,-0.307692},{-122,-0.307692}},
                                                   color={0,0,127}));
    connect(hvac.TMix, controller.TMix) annotation (Line(points={{1,-4},{14,-4},{
            14,-46},{-128,-46},{-128,-4},{-122,-4}}, color={0,0,127}));
    connect(occSch.tNexOcc, controller.tNexOcc) annotation (Line(points={{-159,56},
            {-150,56},{-150,14.4615},{-122,14.4615}},
                                            color={0,0,127}));
    connect(controller.uOcc, occSch.occupied) annotation (Line(points={{-122,
            7.07692},{-152,7.07692},{-152,44},{-159,44}},
                                          color={255,0,255}));
    connect(uWin.y, controller.uWin) annotation (Line(points={{-159,-50},{-148,
            -50},{-148,-11.3846},{-122,-11.3846}},
                                         color={255,0,255}));
    connect(occSch.occupied, occPer.u) annotation (Line(points={{-159,44},{-152,
            44},{-152,0},{-190,0},{-190,-80},{-182,-80}},   color={255,0,255}));
    connect(occPer.y, ppl.u)
      annotation (Line(points={{-159,-80},{-155.2,-80}}, color={0,0,127}));
    connect(ppl.y, controller.nOcc) annotation (Line(points={{-141.4,-80},{-138,
            -80},{-138,-7.69231},{-122,-7.69231}},
                                       color={0,0,127}));
    connect(controller.TZonCooSet, errTRooCoo.u2) annotation (Line(points={{-79,-4},
            {-76,-4},{-76,-132},{-100,-132},{-100,-118}},
          color={0,0,127}));
    connect(hvac.uCooVal, controller.yCooCoi) annotation (Line(points={{-42,5},
            {-48,5},{-48,4},{-58,4},{-58,-15.0769},{-79,-15.0769}},
                                                         color={0,0,127}));
    connect(hvac.TRet, controller.TCut) annotation (Line(points={{1,-6},{12,-6},{
            12,-48},{-132,-48},{-132,3.38462},{-122,3.38462}},
                                                   color={0,0,127}));

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-200,-160},{120,140}})),
      experiment(
        StopTime=31536000,
        Interval=3600.00288,
        Tolerance=1e-06),
        __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/SingleZone/VAV/Examples/Guideline36.mos"
          "Simulate and plot"),
        Documentation(info="<html>
<p>
Implementation of <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Examples.BaseClasses.PartialOpenLoop\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Examples.BaseClasses.PartialOpenLoop</a>
with ASHRAE Guideline 36 control sequence.
</p>
</html>",   revisions="<html>
<ul>
<li>
July 29, 2019, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
  end OptimalStartVAV;

  package BaseClasses
    extends Modelica.Icons.BasesPackage;
    block Controller
      "Single Zone AHU controller that composes subsequences for controlling fan speed, economizer, and supply air temperature"
      parameter Modelica.SIunits.Temperature TZonHeaOn=293.15
        "Heating setpoint during on"
      annotation (Dialog(group="Zone setpoints"));
      parameter Modelica.SIunits.Temperature TZonHeaOff=285.15
        "Heating setpoint during off"
      annotation (Dialog(group="Zone setpoints"));
      parameter Modelica.SIunits.Temperature TZonCooOn=297.15
        "Cooling setpoint during on"
      annotation (Dialog(group="Zone setpoints"));
      parameter Modelica.SIunits.Temperature TZonCooOff=303.15
        "Cooling setpoint during off"
      annotation (Dialog(group="Zone setpoints"));

      parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=
         Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
        annotation (Dialog(group="Cooling loop signal"));

      parameter Real kCoo(final unit="1/K") = 0.1
        "Gain for cooling control loop signal"
        annotation(Dialog(group="Cooling loop signal"));

      parameter Modelica.SIunits.Time TiCoo=900
        "Time constant of integrator block for cooling control loop signal"
        annotation(Dialog(group="Cooling loop signal",
          enable=controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
              or controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

      parameter Modelica.SIunits.Time TdCoo=0.1
        "Time constant of derivative block for cooling control loop signal"
        annotation (Dialog(group="Cooling loop signal",
          enable=controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
              or controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

      parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=
        Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        "Type of controller"
        annotation(Dialog(group="Heating loop signal"));
      parameter Real kHea(final unit="1/K")=0.1
        "Gain for heating control loop signal"
        annotation(Dialog(group="Heating loop signal"));

      parameter Modelica.SIunits.Time TiHea=900
        "Time constant of integrator block for heating control loop signal"
        annotation(Dialog(group="Heating loop signal",
        enable=controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
            or controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

      parameter Modelica.SIunits.Time TdHea=0.1
        "Time constant of derivative block for heating control loop signal"
        annotation (Dialog(group="Heating loop signal",
          enable=controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
              or controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
      parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCooCoi=
        Buildings.Controls.OBC.CDL.Types.SimpleController.P
        "Type of controller"
        annotation(Dialog(group="Cooling coil loop signal"));
      parameter Real kCooCoi(final unit="1/K")=1.0
        "Gain for cooling coil control loop signal"
        annotation(Dialog(group="Cooling coil loop signal"));

      parameter Modelica.SIunits.Time TiCooCoil=900
        "Time constant of integrator block for cooling coil control loop signal"
        annotation(Dialog(group="Cooling coil loop signal",
        enable=controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
            or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

      parameter Modelica.SIunits.Time TdCooCoil=0.1
        "Time constant of derivative block for cooling coil control loop signal"
        annotation (Dialog(group="Cooling coil loop signal",
          enable=controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
              or controllerTypeCooCoi == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
      parameter Modelica.SIunits.Temperature TSupSetMax
        "Maximum supply air temperature for heating"
        annotation (Evaluate=true,
          Dialog(tab="VAV Setpoints",group="Temperature limits"));
      parameter Modelica.SIunits.Temperature TSupSetMin
        "Minimum supply air temperature for cooling"
        annotation (Evaluate=true,
          Dialog(tab="VAV Setpoints",group="Temperature limits"));
      parameter Real yHeaMax(min=0, max=1, unit="1")
        "Maximum fan speed for heating"
        annotation (Dialog(tab="VAV Setpoints",group="Speed"));
      parameter Real yMin(min=0, max=1, unit="1")
        "Minimum fan speed"
        annotation (Dialog(tab="VAV Setpoints",group="Speed"));
      parameter Real yCooMax(min=0, max=1, unit="1") = 1
        "Maximum fan speed for cooling"
        annotation (Dialog(tab="VAV Setpoints",group="Speed"));

      parameter Real VOutPerAre_flow(final unit="m3/(s.m2)") = 3e-4
        "Outdoor air rate per unit area"
        annotation(Dialog(tab="Outside Air Flow", group="Nominal condition"));
      parameter Modelica.SIunits.VolumeFlowRate VOutPerPer_flow = 2.5e-3
        "Outdoor air rate per person"
        annotation(Dialog(tab="Outside Air Flow", group="Nominal condition"));
      parameter Modelica.SIunits.Area AFlo
        "Floor area"
        annotation(Dialog(tab="Outside Air Flow", group="Nominal condition"));
      parameter Boolean have_occSen
        "Set to true if zones have occupancy sensor"
        annotation(Dialog(tab="Outside Air Flow", group="Occupancy"));
      parameter Real occDen(final unit="1/m2") = 0.05
        "Default number of person in unit area"
        annotation(Dialog(tab="Outside Air Flow", group="Occupancy"));
      parameter Real zonDisEffHea(final unit="1") = 0.8
        "Zone air distribution effectiveness during heating"
        annotation(Dialog(tab="Outside Air Flow", group="Occupancy"));
      parameter Real zonDisEffCoo(final unit="1") = 1.0
        "Zone air distribution effectiveness during cooling"
        annotation(Dialog(tab="Outside Air Flow", group="Occupancy"));
      parameter Boolean use_enthalpy = false
        "Set to true if enthalpy measurement is used in addition to temperature measurement"
        annotation(Dialog(tab="Economizer", group="General", enable=not use_fixed_plus_differential_drybulb));
      parameter Boolean use_fixed_plus_differential_drybulb = false
        "Set to true to only evaluate fixed plus differential dry bulb temperature high limit cutoff;
    shall not be used with enthalpy"
        annotation(Dialog(tab="Economizer", group="General", enable=not use_enthalpy));
      parameter Boolean use_TMix=true
        "Set to true if mixed air temperature measurement is enabled"
        annotation(Dialog(tab="Economizer", group="General"));
      parameter Boolean use_G36FrePro=false
        "Set to true if G36 freeze protection is implemented"
        annotation(Dialog(tab="Economizer", group="General"));
      parameter Modelica.SIunits.TemperatureDifference delTOutHis=1
        "Delta between the temperature hysteresis high and low limit"
        annotation(Dialog(tab="Economizer", group="Advanced"));
      parameter Modelica.SIunits.SpecificEnergy delEntHis=1000
        "Delta between the enthalpy hysteresis high and low limits"
         annotation(Dialog(tab="Economizer", group="Advanced", enable = use_enthalpy));
      parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeMod=
        Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        "Type of controller"
        annotation(Dialog(tab="Economizer", group="Modulation"));
      parameter Real kMod(final unit="1/K")=1 "Gain of modulation controller"
        annotation(Dialog(tab="Economizer", group="Modulation"));
      parameter Modelica.SIunits.Time TiMod=300
        "Time constant of modulation controller integrator block"
        annotation (Dialog(tab="Economizer", group="Modulation",
          enable=controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
              or controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
      parameter Modelica.SIunits.Time TdMod=0.1
        "Time constant of derivative block for modulation controller"
        annotation (Dialog(tab="Economizer", group="Modulation",
          enable=controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
              or controllerTypeMod == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
      parameter Real uMin(
        final min=0,
        final max=1,
        final unit="1") = 0.1
        "Lower limit of controller output uTSup at which the dampers are at their limits"
        annotation(Dialog(tab="Economizer", group="General"));

      parameter Real uMax(
        final min=0,
        final max=1,
        final unit="1") = 0.9
        "Upper limit of controller output uTSup at which the dampers are at their limits"
        annotation(Dialog(tab="Economizer", group="General"));

      parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeFre=
        Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        "Type of controller"
        annotation(Dialog(tab="Economizer", group="Freeze protection", enable=use_TMix));

      parameter Real kFre(final unit="1/K") = 0.1
        "Gain for mixed air temperature tracking for freeze protection, used if use_TMix=true"
         annotation(Dialog(tab="Economizer", group="Freeze protection", enable=use_TMix));

      parameter Modelica.SIunits.Time TiFre=120
        "Time constant of controller for mixed air temperature tracking for freeze protection. Require TiFre < TiMinOut"
         annotation(Dialog(tab="Economizer", group="Freeze protection",
           enable=use_TMix
             and (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
               or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

       parameter Modelica.SIunits.Time TdFre=0.1
         "Time constant of derivative block for freeze protection"
         annotation (Dialog(tab="Economizer", group="Freeze protection",
           enable=use_TMix and
               (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
               or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

      parameter Modelica.SIunits.Temperature TFreSet=277.15
        "Lower limit for mixed air temperature for freeze protection, used if use_TMix=true"
         annotation(Dialog(tab="Economizer", group="Freeze protection", enable=use_TMix));

      parameter Modelica.SIunits.VolumeFlowRate VOutMin_flow=1.0
        "Calculated minimum outdoor airflow rate"
        annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
      parameter Modelica.SIunits.VolumeFlowRate VOutDes_flow=2.0
        "Calculated design outdoor airflow rate"
        annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
      parameter Real yDam_VOutMin_minSpe(
        final min=outDamPhyPosMin,
        final max=outDamPhyPosMax,
        final unit="1") = 0.4
        "OA damper position to supply minimum outdoor airflow at minimum fan speed"
        annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
      parameter Real yDam_VOutMin_maxSpe(
        final min=outDamPhyPosMin,
        final max=outDamPhyPosMax,
        final unit="1") = 0.3
        "OA damper position to supply minimum outdoor airflow at maximum fan speed"
        annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
      parameter Real yDam_VOutDes_minSpe(
        final min=yDam_VOutMin_minSpe,
        final max=outDamPhyPosMax,
        final unit="1") = 0.9
        "OA damper position to supply design outdoor airflow at minimum fan speed"
        annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
      parameter Real yDam_VOutDes_maxSpe(
        final min=yDam_VOutMin_maxSpe,
        final max=outDamPhyPosMax,
        final unit="1") = 0.8
        "OA damper position to supply design outdoor airflow at maximum fan speed"
        annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
      parameter Real outDamPhyPosMax(
        final min=0,
        final max=1,
        final unit="1") = 1
        "Physically fixed maximum position of the outdoor air (OA) damper"
        annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
      parameter Real outDamPhyPosMin(
        final min=0,
        final max=1,
        final unit="1") = 0
        "Physically fixed minimum position of the outdoor air damper"
        annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
      parameter Real retDamPhyPosMax(
        final min=0,
        final max=1,
        final unit="1") = 1
        "Physically fixed maximum position of the return air damper"
        annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));
      parameter Real retDamPhyPosMin(
        final min=0,
        final max=1,
        final unit="1") = 0
        "Physically fixed minimum position of the return air damper"
        annotation(Evaluate=true, Dialog(tab="Economizer", group="Commissioning"));

      Buildings.Controls.OBC.Utilities.Examples.BaseClasses.ModeAndSetPoints
        modSetPoi(
        TZonHeaOn=TZonHeaOn,
        TZonHeaOff=TZonHeaOff,
        TZonCooOn=TZonCooOn,
        TZonCooOff=TZonCooOff)
        "Output zone setpoint with operation mode selection"
        annotation (Placement(transformation(extent={{-180,180},{-160,200}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc
        "Time to next occupied period"
        annotation (Placement(transformation(extent={{-240,180},{-200,220}}),
            iconTransformation(extent={{-240,180},{-200,220}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
        final unit="K",
        final quantity = "ThermodynamicTemperature")
        "Measured zone temperatures"
        annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
            iconTransformation(extent={{-240,140},{-200,180}})));
      Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
        "Current occupancy period, true if it is in occupant period"
        annotation (Placement(transformation(extent={{-240,100},{-200,140}}),
            iconTransformation(extent={{-240,100},{-200,140}})));
      Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply
        setPoiVAV(
        final TSupSetMax=TSupSetMax,
        final TSupSetMin=TSupSetMin,
        final yHeaMax=yHeaMax,
        final yMin=yMin,
        final yCooMax=yCooMax)
        "Supply air set point and fan signal for single zone VAV system"
        annotation (Placement(transformation(extent={{40,180},{60,200}})));
      Buildings.Controls.OBC.CDL.Continuous.LimPID cooPI(
        final reverseAction=true,
        final controllerType=controllerTypeCoo,
        final k=kCoo,
        final Ti=TiCoo,
        final Td=TdCoo,
        final yMax=1,
        final yMin=0,
        reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
                      "Zone cooling control signal"
        annotation (Placement(transformation(extent={{-48,150},{-28,170}})));
      Buildings.Controls.OBC.CDL.Continuous.LimPID heaPI(
        final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
        final controllerType=controllerTypeHea,
        final k=kHea,
        final Ti=TiHea,
        final Td=TdHea,
        final yMax=1,
        final yMin=0) "Zone heating control signal"
        annotation (Placement(transformation(extent={{-48,200},{-28,220}})));
      Buildings.Controls.OBC.CDL.Continuous.Average ave
        "Average of zone heating and cooling setpoint"
        annotation (Placement(transformation(extent={{-100,180},{-80,200}})));
      Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Controller
        conEco(
        final use_TMix=use_TMix,
        final use_G36FrePro=use_G36FrePro,
        final delTOutHis=delTOutHis,
        final delEntHis=delEntHis,
        final controllerTypeMod=controllerTypeMod,
        final kMod=kMod,
        final TiMod=TiMod,
        final TdMod=TdMod,
        final uMin=uMin,
        final uMax=uMax,
        final controllerTypeFre=controllerTypeFre,
        final kFre=kFre,
        final TiFre=TiFre,
        final TdFre=TdFre,
        final TFreSet=TFreSet,
        final VOutMin_flow=VOutMin_flow,
        final VOutDes_flow=VOutDes_flow,
        final yDam_VOutMin_maxSpe=yDam_VOutMin_maxSpe,
        final yDam_VOutDes_minSpe=yDam_VOutDes_minSpe,
        final yDam_VOutDes_maxSpe=yDam_VOutDes_maxSpe,
        final outDamPhyPosMax=outDamPhyPosMax,
        final outDamPhyPosMin=outDamPhyPosMin,
        final retDamPhyPosMax=retDamPhyPosMax,
        final retDamPhyPosMin=retDamPhyPosMin,
        final use_enthalpy=use_enthalpy,
        final use_fixed_plus_differential_drybulb=use_fixed_plus_differential_drybulb,
        final yFanMin=0,
        final yFanMax=1) "Economizer control sequence"
               annotation (Placement(transformation(extent={{118,-48},{138,-28}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealInput TCut(final unit="K", final
          quantity="ThermodynamicTemperature")
        "Economizer high limit cutoff. Fixed dry bulb or differential dry bulb temeprature"
        annotation (Placement(transformation(extent={{-240,60},{-200,100}}),
            iconTransformation(extent={{-240,60},{-200,100}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
        final unit="K",
        final quantity = "ThermodynamicTemperature")
        "Measured supply air temperature"
        annotation (Placement(transformation(extent={{-240,20},{-200,60}}),
            iconTransformation(extent={{-240,20},{-200,60}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
        final unit="K",
        final quantity = "ThermodynamicTemperature") if use_TMix
        "Measured mixed air temperature, used for freeze protection if use_TMix is true"
        annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
            iconTransformation(extent={{-240,-20},{-200,20}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc(final unit="1") if
           have_occSen "Number of occupants"
        annotation (Placement(transformation(extent={{-240,-60},{-200,-20}}),
            iconTransformation(extent={{-240,-60},{-200,-20}})));
      Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin
        "Window status, true if open, false if closed"
        annotation (Placement(transformation(extent={{-240,-100},{-200,-60}}),
            iconTransformation(extent={{-240,-100},{-200,-60}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupHeaEco(
        final unit="K",
        final quantity = "ThermodynamicTemperature")
        "Temperature setpoint for heating coil and for economizer"
        annotation (Placement(transformation(extent={{200,230},{220,250}}),
            iconTransformation(extent={{200,210},{220,230}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupCoo(
        final unit="K",
        final quantity = "ThermodynamicTemperature")
        "Cooling supply air temperature setpoint"
        annotation (Placement(transformation(extent={{200,170},{220,190}}),
            iconTransformation(extent={{200,160},{220,180}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFan(
        final min=0,
        final max=1,
        final unit="1") "Fan speed"
        annotation (Placement(transformation(extent={{200,110},{220,130}}),
            iconTransformation(extent={{200,110},{220,130}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
        final min=0,
        final max=1,
        final unit="1")
        "Return air damper position"
        annotation (Placement(transformation(extent={{200,-250},{220,-230}}),
            iconTransformation(extent={{200,-230},{220,-210}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
        final min=0,
        final max=1,
        final unit="1")
        "Outdoor air damper position"
        annotation (Placement(transformation(extent={{200,-190},{220,-170}}),
            iconTransformation(extent={{200,-180},{220,-160}})));
      Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.OutsideAirFlow
        outAirSetPoi(
        final AFlo=AFlo,
        final have_occSen=have_occSen,
        final VOutPerAre_flow=VOutPerAre_flow,
        final VOutPerPer_flow=VOutPerPer_flow,
        final occDen=occDen,
        final zonDisEffHea=zonDisEffHea,
        final zonDisEffCoo=zonDisEffCoo)
        "Output the minimum outdoor airflow rate setpoint "
        annotation (Placement(transformation(extent={{40,40},{60,60}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
        final unit="K",
        final quantity = "ThermodynamicTemperature")
        "Outside air temperature"
        annotation (Placement(transformation(extent={{-240,220},{-200,260}}),
            iconTransformation(extent={{-240,220},{-200,260}})));
      ASHRAE.G36_PR1.AHUs.SingleZone.VAV.ZoneState zonSta "Zone state"
        annotation (Placement(transformation(extent={{40,130},{60,150}})));
      CDL.Integers.Sources.Constant conInt(k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
        "Unoccupied mode"
        annotation (Placement(transformation(extent={{-160,-240},{-140,-220}})));
      CDL.Integers.Equal intEqu
        "Check if current operation mode is unoccupied mode"
        annotation (Placement(transformation(extent={{-110,-240},{-90,-220}})));
      CDL.Logical.Not switch "If in unoccupied mode, switch off"
        annotation (Placement(transformation(extent={{-80,-240},{-60,-220}})));
      CDL.Interfaces.IntegerInput uFreProSta if use_G36FrePro
       "Freeze protection status, used if use_G36FrePro=true" annotation (
         Placement(transformation(extent={{-240,-260},{-200,-220}}),
            iconTransformation(extent={{-240,-260},{-200,-220}})));
      CDL.Interfaces.RealInput hOut(
        final unit="J/kg",
        final quantity="SpecificEnergy") if use_enthalpy "Outdoor air enthalpy"
        annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
            iconTransformation(extent={{-240,-140},{-200,-100}})));
      CDL.Interfaces.RealInput hCut(final unit="J/kg", final quantity="SpecificEnergy") if
           use_enthalpy
        "Economizer enthalpy high limit cutoff. Fixed enthalpy or differential enthalpy"
        annotation (Placement(transformation(extent={{-240,-180},{-200,-140}}),
            iconTransformation(extent={{-240,-180},{-200,-140}})));
      CDL.Interfaces.RealOutput yHeaCoi(
        final min=0,
        final max=1,
        final unit="1") "Heating coil control signal"
        annotation (Placement(transformation(extent={{200,-70},{220,-50}}),
            iconTransformation(extent={{200,-68},{220,-48}})));
      CDL.Interfaces.RealOutput yCooCoi(
        final min=0,
        final max=1,
        final unit="1") "Cooling coil control signal" annotation (
          Placement(transformation(extent={{200,-130},{220,-110}}),
            iconTransformation(extent={{200,-130},{220,-110}})));
      CDL.Interfaces.RealOutput TZonHeaSet(
        final unit="K",
        final quantity = "ThermodynamicTemperature")  "Zone heating setpoint temperature"
        annotation (Placement(transformation(extent={{200,50},{220,70}}),
            iconTransformation(extent={{200,50},{220,70}})));
      CDL.Interfaces.RealOutput TZonCooSet(
        final unit="K",
        final quantity = "ThermodynamicTemperature")  "Zone cooling setpoint temperature"
        annotation (Placement(transformation(extent={{200,-10},{220,10}}),
            iconTransformation(extent={{200,-10},{220,10}})));
      CDL.Interfaces.RealInput TRet(
        final unit="K",
        final quantity="ThermodynamicTemperature") if
           use_fixed_plus_differential_drybulb
        "Used only for fixed plus differential dry bulb temperature high limit cutoff"
        annotation (Placement(transformation(extent={{-240,-220},{-200,-180}}),
            iconTransformation(extent={{-240,-220},{-200,-180}})));
      ASHRAE.G36_PR1.AHUs.SingleZone.VAV.CoolingCoil cooCoi(controllerTypeCooCoi=
            controllerTypeCooCoi, kCooCoi=kCooCoi)
        "Controller for cooling coil valve"
        annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
    equation
      connect(modSetPoi.tNexOcc, tNexOcc) annotation (Line(points={{-181,198},{-200,
              198},{-200,200},{-220,200}},      color={0,0,127}));
      connect(ave.y, setPoiVAV.TZonSet) annotation (Line(points={{-78,190},{-14,
              190},{-14,191.667},{38,191.667}},
                                           color={0,0,127}));
      connect(TCut, conEco.TCut) annotation (Line(points={{-220,80},{-90,80},{-90,
              -30.2},{117,-30.2}},
                          color={0,0,127}));
      connect(conEco.TSup, TSup) annotation (Line(points={{117,-36.6},{-4,-36.6},{
              -4,40},{-220,40}},
                              color={0,0,127}));
      connect(setPoiVAV.TSupHeaEco, conEco.THeaSupSet) annotation (Line(points={{62,195},
              {92,195},{92,-38.2},{117,-38.2}},   color={0,0,127}));
      connect(setPoiVAV.y, conEco.uSupFanSpe) annotation (Line(points={{62,185},{86,
              185},{86,-41},{117,-41}},
                                      color={0,0,127}));
      connect(TMix, conEco.TMix) annotation (Line(points={{-220,0},{0,0},{0,-42.4},
              {117,-42.4}},   color={0,0,127}));
      connect(setPoiVAV.TSupHeaEco, TSupHeaEco) annotation (Line(points={{62,195},{
              160,195},{160,240},{210,240}},  color={0,0,127}));
      connect(setPoiVAV.TSupCoo, TSupCoo) annotation (Line(points={{62,190},{136,190},
              {136,180},{210,180}},      color={0,0,127}));
      connect(setPoiVAV.y, yFan) annotation (Line(points={{62,185},{120,185},{120,
              120},{210,120}}, color={0,0,127}));
      connect(conEco.yRetDamPos, yRetDamPos) annotation (Line(points={{139,-38},{168,
              -38},{168,-240},{210,-240}},   color={0,0,127}));
      connect(conEco.yOutDamPos, yOutDamPos) annotation (Line(points={{139,-42},{160,
              -42},{160,-180},{210,-180}}, color={0,0,127}));
      connect(outAirSetPoi.TDis, TSup) annotation (Line(points={{38,47},{-4,47},{-4,
              40},{-220,40}},      color={0,0,127}));
      connect(conEco.VOutMinSet_flow, outAirSetPoi.VOutMinSet_flow) annotation (
          Line(points={{117,-39.6},{108,-39.6},{108,50},{62,50}},
                                                           color={0,0,127}));
      connect(TOut, setPoiVAV.TOut) annotation (Line(points={{-220,240},{10,240},{
              10,185},{38,185}}, color={0,0,127}));
      connect(conEco.TOut, setPoiVAV.TOut) annotation (Line(points={{117,-28.6},{10,
              -28.6},{10,185},{38,185}},
                                       color={0,0,127}));
      connect(zonSta.yZonSta, conEco.uZonSta) annotation (Line(points={{61,140},{80,
              140},{80,-46.2},{117,-46.2}},
                                        color={255,127,0}));
      connect(conInt.y, intEqu.u2) annotation (Line(points={{-138,-230},{-130,-230},
              {-130,-238},{-112,-238}},color={255,127,0}));
      connect(intEqu.y, switch.u) annotation (Line(points={{-88,-230},{-82,-230}}, color={255,0,255}));
      connect(modSetPoi.TZonHeaSet, ave.u2) annotation (Line(points={{-159,193},{
              -134,193},{-134,184},{-102,184}},color={0,0,127}));
      connect(modSetPoi.TZonHeaSet, heaPI.u_s) annotation (Line(points={{-159,193},
              {-124,193},{-124,210},{-50,210}}, color={0,0,127}));
      connect(modSetPoi.TZonCooSet, ave.u1) annotation (Line(points={{-159,197},{
              -102,197},{-102,196}},         color={0,0,127}));
      connect(modSetPoi.TZonCooSet, cooPI.u_s) annotation (Line(points={{-159,197},
              {-114,197},{-114,160},{-50,160}},
                                              color={0,0,127}));
      connect(outAirSetPoi.uWin, uWin) annotation (Line(points={{38,54},{8,54},{8,-80},
              {-220,-80}},      color={255,0,255}));
      connect(modSetPoi.uOcc, uOcc) annotation (Line(points={{-181,186.025},{-184,
              186.025},{-184,120},{-220,120}}, color={255,0,255}));
      connect(TZon, modSetPoi.TZon) annotation (Line(points={{-220,160},{-198,160},
              {-198,195},{-181,195}}, color={0,0,127}));
      connect(TZon, cooPI.u_m) annotation (Line(points={{-220,160},{-180,160},{-180,
              132},{-38,132},{-38,148}}, color={0,0,127}));
      connect(setPoiVAV.TZon, cooPI.u_m) annotation (Line(points={{38,188.333},
              {4,188.333},{4,132},{-38,132},{-38,148}},
                                            color={0,0,127}));
      connect(outAirSetPoi.TZon, cooPI.u_m)   annotation (Line(points={{38,50},{-38,
              50},{-38,148}},                                                                       color={0,0,127}));
      connect(nOcc, outAirSetPoi.nOcc) annotation (Line(points={{-220,-40},{4,-40},{
              4,58},{38,58}},  color={0,0,127}));
      connect(uFreProSta, conEco.uFreProSta) annotation (Line(points={{-220,-240},{
              -180,-240},{-180,-180},{40,-180},{40,-47.6},{117,-47.6}},
                                       color={255,127,0}));
      connect(conEco.hOut, hOut) annotation (Line(points={{117,-33.4},{100,-33.4},{
              100,-120},{-220,-120}},
                            color={0,0,127}));
      connect(conEco.hCut, hCut) annotation (Line(points={{117,-35},{102,-35},{102,
              -160},{-220,-160}},
                            color={0,0,127}));
      connect(conEco.TRet, TRet) annotation (Line(points={{117,-31.8},{102,-31.8},{
              102,-200},{-220,-200}},
                            color={0,0,127}));
      connect(conEco.yHeaCoi, yHeaCoi) annotation (Line(points={{139,-34},{174,-34},
              {174,-60},{210,-60}}, color={0,0,127}));
      connect(modSetPoi.yOpeMod, conEco.uOpeMod) annotation (Line(points={{-159,187},
              {-152,187},{-152,-45},{117,-45}}, color={255,127,0}));
      connect(modSetPoi.TZonHeaSet, TZonHeaSet) annotation (Line(points={{-159,193},
              {-140,193},{-140,100},{146,100},{146,60},{210,60}}, color={0,0,127}));
      connect(cooCoi.yCooCoi, yCooCoi)
        annotation (Line(points={{141,-120},{210,-120}}, color={0,0,127}));
      connect(switch.y, cooCoi.uSupFan) annotation (Line(points={{-58,-230},{110,-230},
              {110,-128},{118,-128}}, color={255,0,255}));
      connect(zonSta.yZonSta, cooCoi.uZonSta) annotation (Line(points={{61,140},{80,
              140},{80,-124},{118,-124}}, color={255,127,0}));
      connect(cooCoi.TSupCoo, TSupCoo) annotation (Line(points={{118,-112},{74,-112},
              {74,190},{136,190},{136,180},{210,180}}, color={0,0,127}));
      connect(cooCoi.TSup, TSup) annotation (Line(points={{118,-116},{-4,-116},{-4,
              40},{-220,40}},
                          color={0,0,127}));
      connect(switch.y, outAirSetPoi.uSupFan) annotation (Line(points={{-58,-230},{-20,
              -230},{-20,44},{38,44}}, color={255,0,255}));
      connect(switch.y, conEco.uSupFan) annotation (Line(points={{-58,-230},{60,
              -230},{60,-43.6},{117,-43.6}},
                                   color={255,0,255}));
      connect(switch.y, setPoiVAV.uFan) annotation (Line(points={{-58,-230},{28,
              -230},{28,181.667},{38,181.667}},
                                  color={255,0,255}));
      connect(heaPI.y, setPoiVAV.uHea) annotation (Line(points={{-26,210},{-12,
              210},{-12,198.333},{38,198.333}},
                                   color={0,0,127}));
      connect(heaPI.y, zonSta.uHea) annotation (Line(points={{-26,210},{-12,210},{
              -12,144},{38,144}},
                              color={0,0,127}));
      connect(cooPI.y, setPoiVAV.uCoo) annotation (Line(points={{-26,160},{-20,160},
              {-20,195},{38,195}}, color={0,0,127}));
      connect(cooPI.y, zonSta.uCoo) annotation (Line(points={{-26,160},{-20,160},{
              -20,136},{38,136}},
                              color={0,0,127}));
      connect(switch.y, heaPI.trigger) annotation (Line(points={{-58,-230},{-46,-230},
              {-46,72},{-58,72},{-58,182},{-46,182},{-46,198}}, color={255,0,255}));
      connect(switch.y, cooPI.trigger) annotation (Line(points={{-58,-230},{-46,-230},
              {-46,148}}, color={255,0,255}));
      connect(modSetPoi.TZonCooSet, TZonCooSet) annotation (Line(points={{-159,197},
              {-114,197},{-114,108},{120,108},{120,0},{210,0}}, color={0,0,127}));
      connect(TZon, heaPI.u_m) annotation (Line(points={{-220,160},{-126,160},{-126,
              178},{-38,178},{-38,198}}, color={0,0,127}));
      connect(intEqu.u1, modSetPoi.yOpeMod) annotation (Line(points={{-112,-230},{
              -120,-230},{-120,-60},{-152,-60},{-152,187},{-159,187}}, color={255,
              127,0}));
      connect(outAirSetPoi.uOpeMod, modSetPoi.yOpeMod) annotation (Line(points={{38,
              41},{34,41},{34,30},{-152,30},{-152,187},{-159,187}}, color={255,127,
              0}));
      annotation (defaultComponentName="conVAV",
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-260},{200,
                260}}),
            graphics={Rectangle(
            extent={{-200,-260},{200,260}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
            Text(
              extent={{-148,312},{152,272}},
              textString="%name",
              lineColor={0,0,255}),
            Text(
              extent={{-192,262},{-138,224}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="TOut"),
            Text(
              extent={{-194,218},{-140,180}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="tNexOcc"),
            Text(
              extent={{-192,180},{-138,142}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="TZon"),
            Text(
              extent={{-192,140},{-138,102}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="uOcc"),
            Text(
              extent={{-192,102},{-138,64}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="TCut"),
            Text(
              extent={{-192,62},{-138,24}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="TSup"),
            Text(
              extent={{-192,20},{-138,-18}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="TMix"),
            Text(
              extent={{-192,-56},{-138,-18}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="nOcc"),
            Text(
              extent={{-192,-58},{-138,-96}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="uWin"),
            Text(
              extent={{-192,-136},{-138,-174}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="hCut"),
            Text(
              extent={{-192,-98},{-138,-136}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="hOut"),
            Text(
              extent={{-192,-180},{-138,-218}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="TRet"),
            Text(
              extent={{-192,-218},{-138,-256}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="uFreProSta"),
            Text(
              extent={{132,242},{186,204}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="TSupHeaEco"),
            Text(
              extent={{136,190},{190,152}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="TSupCoo"),
            Text(
              extent={{136,140},{190,102}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="yFan"),
            Text(
              extent={{136,82},{190,44}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="TZonHeaSet"),
            Text(
              extent={{140,22},{194,-16}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="TZonCooSet"),
            Text(
              extent={{140,-34},{194,-72}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="yHeaCoi"),
            Text(
              extent={{140,-98},{194,-136}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="yCooCoi"),
            Text(
              extent={{138,-150},{192,-188}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="yOutDamPos"),
            Text(
              extent={{140,-200},{194,-238}},
              lineColor={0,0,127},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid,
              textString="yRetDamPos")}),
              Diagram(coordinateSystem(
              preserveAspectRatio=false, extent={{-200,-260},{200,260}})),
    Documentation(info="<html>
<p>
Block for single zone VAV control. It outputs supply fan speed, supply air temperature
setpoints for heating, economizer and cooling, zone air heating and cooling setpoints,
outdoor and return air damper positions, and valve positions of heating and cooling coils.
</p>
<p>
It is implemented according to the ASHRAE Guideline 36, Part 5.18.
</p>
<p>
The sequences consist of the following subsequences.
</p>
<h4>Supply fan speed control</h4>
<p>
The fan speed control is implemented according to PART 5.18.4. It outputs
the control signal <code>yFan</code> to adjust the speed of the supply fan.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply</a>
for more detailed description.
</p>
<h4>Supply air temperature setpoints</h4>
<p>
The supply air temperature setpoints control sequences are implemented based on PART 5.18.4.
They are implemented in the same control block as the supply fan speed control. The supply air temperature setpoint
for heating and economizer is the same; while the supply air temperature setpoint for cooling has
a separate control loop. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.Supply</a>
for more detailed description.
</p>
<h4>Economizer control</h4>
<p>
The Economizer control block outputs outdoor and return air damper position, i.e. <code>yOutDamPos</code> and
<code>yRetDamPos</code>, as well as control signal for heating coil <code>yHeaCoi</code>.
Optionally, there is also an override for freeze protection, which is not part of Guideline 36.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Economizers.Controller</a>
for more detailed description.
</p>
<h4>Minimum outdoor airflow</h4>
<p>
Control sequences are implemented to compute the minimum outdoor airflow
setpoint, which is used as an input for the economizer control. More detailed
information can be found at
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.OutsideAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints.OutsideAirFlow</a>.
</p>
<h4>Zone air heating and cooling setpoints</h4>
<p>
Zone air heating and cooling setpoints as well as system operation modes are detailed at
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.ModeAndSetPoints\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.ModeAndSetPoints</a>.
</p>
</html>",
    revisions="<html>
<ul>
<li>
August 3, 2019, by David Blum &amp; Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"));
    end Controller;

    block ModeAndSetPoints "Output zone setpoint with operation mode selection"

      parameter Modelica.SIunits.Temperature TZonHeaOn=293.15
        "Heating setpoint during on";
      parameter Modelica.SIunits.Temperature TZonHeaOff=285.15
        "Heating setpoint during off";
      parameter Modelica.SIunits.Temperature TZonCooOn=297.15
        "Cooling setpoint during on";
      parameter Modelica.SIunits.Temperature TZonCooOff=303.15
        "Cooling setpoint during off";
      parameter Modelica.SIunits.Time preWarCooTim=10800
        "Maximum cool-down/warm-up time"
        annotation (Evaluate=true, Dialog(tab="Operation mode", group="Parameters"));
      parameter Modelica.SIunits.TemperatureDifference bouLim=1.1
        "Value limit to indicate the end of setback/setup mode"
        annotation (Evaluate=true, Dialog(tab="Operation mode", group="Parameters"));
      parameter Modelica.SIunits.Temperature TZonFreProOn=277.55
        "Threshold zone temperature value to activate freeze protection mode"
        annotation (Evaluate=true, Dialog(tab="Operation mode", group="Parameters"));
      parameter Modelica.SIunits.Temperature TZonFreProOff=280.35
        "Threshold zone temperature value to finish the freeze protection mode"
        annotation (Evaluate=true, Dialog(tab="Operation mode", group="Parameters"));
      parameter Modelica.SIunits.Time warCooTim=1800
        "Defined cool-down/warm-up time"
        annotation (Evaluate=true, Dialog(tab="Operation mode", group="Test setting"));
      parameter Boolean have_occSen=false
        "Check if the zone has occupancy sensor"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Sensors"));
      parameter Boolean have_winSen=false
        "Check if the zone has window status sensor"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Sensors"));
      parameter Boolean cooAdj=false
        "Flag, set to true if both cooling and heating setpoint are adjustable separately"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Adjustable settings"));
      parameter Boolean heaAdj=false
        "Flag, set to true if heating setpoint is adjustable"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Adjustable settings"));
      parameter Boolean sinAdj=false
        "Flag, set to true if both cooling and heating setpoint are adjustable through a single common knob"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Adjustable settings"));
      parameter Boolean ignDemLim=true
        "Flag, set to true to exempt individual zone from demand limit setpoint adjustment"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Adjustable settings"));
      parameter Modelica.SIunits.Temperature TZonCooOnMax=300.15
        "Maximum cooling setpoint during on"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits"));
      parameter Modelica.SIunits.Temperature TZonCooOnMin=295.15
        "Minimum cooling setpoint during on"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits"));
      parameter Modelica.SIunits.Temperature TZonHeaOnMax=295.15
        "Maximum heating setpoint during on"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits"));
      parameter Modelica.SIunits.Temperature TZonHeaOnMin=291.15
        "Minimum heating setpoint during on"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits"));
      parameter Modelica.SIunits.Temperature TZonCooSetWinOpe=322.15
        "Cooling setpoint when window is open"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits"));
      parameter Modelica.SIunits.Temperature TZonHeaSetWinOpe=277.15
        "Heating setpoint when window is open"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Limits"));
      parameter Modelica.SIunits.TemperatureDifference incTSetDem_1=0.56
        "Cooling setpoint increase value when cooling demand limit level 1 is imposed"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
      parameter Modelica.SIunits.TemperatureDifference incTSetDem_2=1.1
        "Cooling setpoint increase value when cooling demand limit level 2 is imposed"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
      parameter Modelica.SIunits.TemperatureDifference incTSetDem_3=2.2
        "Cooling setpoint increase value when cooling demand limit level 3 is imposed"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
      parameter Modelica.SIunits.TemperatureDifference decTSetDem_1=0.56
        "Heating setpoint decrease value when heating demand limit level 1 is imposed"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
      parameter Modelica.SIunits.TemperatureDifference decTSetDem_2=1.1
        "Heating setpoint decrease value when heating demand limit level 2 is imposed"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
      parameter Modelica.SIunits.TemperatureDifference decTSetDem_3=2.2
        "Heating setpoint decrease value when heating demand limit level 3 is imposed"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust", group="Demands settings"));
      parameter Integer cooDemLimLevCon=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.DemandLimitLevels.cooling0
        "Cooling demand limit level"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust"));
      parameter Integer heaDemLimLevCon=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.DemandLimitLevels.heating0
        "Heating demand limit level"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust"));
      parameter Boolean winStaCon=false
        "Window status, set to true if window is open"
        annotation (Evaluate=true, Dialog(tab="Setpoint adjust"));

      Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
        final unit="K",
        quantity="ThermodynamicTemperature")
        "Measured zone temperatures"
        annotation (Placement(transformation(extent={{-180,60},{-140,100.5}}),
          iconTransformation(extent={{-120,40},{-100,60}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealInput tNexOcc(
        final unit="s",
        quantity="Time")
        "Time to next occupied period"
        annotation (Placement(transformation(extent={{-180,120},{-140,160}}),
          iconTransformation(extent={{-120,70},{-100,90}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealInput setAdj(
        final unit="K",
        quantity="ThermodynamicTemperature") if (cooAdj or sinAdj)
        "Setpoint adjustment value"
        annotation (Placement(transformation(extent={{-20,-20},{20,20}},origin={-160,-40}),
                            iconTransformation(extent={{-120,10},{-100,30}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealInput heaSetAdj(
        final unit="K",
        quantity="ThermodynamicTemperature") if heaAdj
        "Heating setpoint adjustment value"
        annotation (Placement(transformation(extent={{-20,-20},{20,20}},origin={-160,-70}), iconTransformation(extent={{-120,-20},{-100,0}})));
      Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc
        "Current occupancy period, true if it is in occupant period"
        annotation (Placement(transformation(extent={{-180,0},{-140,40.5}}),
          iconTransformation(extent={{-120,-50},{-100,-29.5}})));
      Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOccSen if have_occSen
        "Occupancy sensor (occupied=true, unoccupied=false)"
        annotation (Placement(transformation(extent={{-180,-130},{-140,-90}}),
          iconTransformation(extent={{-120,-80},{-100,-60}})));
      Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWinSta if have_winSen
        "Window status (open=true, close=false)"
        annotation (Placement(transformation(extent={{-180,-170},{-140,-130}}),
          iconTransformation(extent={{-120,-100},{-100,-80}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonCooSet(
        final unit="K",
        quantity="ThermodynamicTemperature") "Cooling setpoint temperature"
        annotation (Placement(transformation(extent={{140,90},{160,110}}),
          iconTransformation(extent={{100,60},{120,80}})));
      Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZonHeaSet(
        final unit="K",
        quantity="ThermodynamicTemperature") "Heating setpoint temperature"
        annotation (Placement(transformation(extent={{140,50},{160,70}}),
          iconTransformation(extent={{100,20},{120,40}})));
      Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yOpeMod
        "Operation mode"
        annotation (Placement(transformation(extent={{140,-10},{160,10}}),
          iconTransformation(extent={{100,-40},{120,-20}})));

      Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures TZonSet(
        final have_occSen=have_occSen,
        final have_winSen=have_winSen,
        final cooAdj=cooAdj,
        final heaAdj=heaAdj,
        final sinAdj=sinAdj,
        final ignDemLim=ignDemLim,
        final TZonCooOnMax=TZonCooOnMax,
        final TZonCooOnMin=TZonCooOnMin,
        final TZonHeaOnMax=TZonHeaOnMax,
        final TZonHeaOnMin=TZonHeaOnMin,
        final TZonCooSetWinOpe=TZonCooSetWinOpe,
        final TZonHeaSetWinOpe=TZonHeaSetWinOpe,
        final incTSetDem_1=incTSetDem_1,
        final incTSetDem_2=incTSetDem_2,
        final incTSetDem_3=incTSetDem_3,
        final decTSetDem_1=decTSetDem_1,
        final decTSetDem_2=decTSetDem_2,
        final decTSetDem_3=decTSetDem_3)
        "Zone set point temperature"
        annotation (Placement(transformation(extent={{60,-62},{100,-22}})));
      Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooDemLimLev(
        k=cooDemLimLevCon)
        "Cooling demand limit level"
        annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
      Buildings.Controls.OBC.CDL.Integers.Sources.Constant heaDemLimLev(
        k=heaDemLimLevCon) "Heating demand limit level"
        annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOn(
        final k=TZonHeaOn)
        "Heating on setpoint"
        annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooHeaOff(
        final k=TZonHeaOff)
        "Heating off set point"
        annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOn(
        final k=TZonCooOn)
        "Cooling on setpoint"
        annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
      Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetRooCooOff(
        final k=TZonCooOff)
        "Cooling off set point"
        annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
      Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode opeModSel(
        final numZon=1,
        final preWarCooTim=preWarCooTim,
        final bouLim=bouLim,
        final TZonFreProOn=TZonFreProOn,
        final TZonFreProOff=TZonFreProOff)
        "Operation mode selector"
        annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
      Buildings.Controls.OBC.CDL.Logical.Sources.Constant cloWin(
        k=false) if not have_winSen
        "Closed window status"
        annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

      Utilities.OptimalStart optStaHea(n=5, heating_only=true)
        annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
      Utilities.OptimalStart optStaCoo(
        n=5,
        heating_only=false,
        cooling_only=true)
        annotation (Placement(transformation(extent={{-60,128},{-40,148}})));
    equation
      connect(TZonSet.uCooDemLimLev,cooDemLimLev. y)
        annotation (Line(points={{58,-56},{36,-56},{36,-90},{22,-90}},
          color={255,127,0}));
      connect(heaDemLimLev.y,TZonSet. uHeaDemLimLev)
        annotation (Line(points={{22,-150},{40,-150},{40,-60},{58,-60}},
          color={255,127,0}));
      connect(opeModSel.TZonHeaSetUno,TSetRooHeaOff. y)
        annotation (Line(points={{-32,-7},{-54,-7},{-54,80},{-78,80}},
          color={0,0,127}));
      connect(opeModSel.TZonCooSetUno,TSetRooCooOff. y)
        annotation (Line(points={{-32,-9},{-56,-9},{-56,40},{-78,40}},
          color={0,0,127}));
      connect(TZonSet.TZonCooSet, TZonCooSet)
        annotation (Line(points={{102,-34},{112,-34},{112,100},{150,100}},
          color={0,0,127}));
      connect(TZonSet.TZonHeaSet, TZonHeaSet)
        annotation (Line(points={{102,-42},{120,-42},{120,60},{150,60}},
          color={0,0,127}));
      connect(opeModSel.yOpeMod, yOpeMod)
        annotation (Line(points={{-8,0},{0,0},{0,-72},{128,-72},{128,0},{150,0}},
          color={255,127,0}));
      connect(setAdj, TZonSet.setAdj)
        annotation (Line(points={{-160,-40},{-52,-40},{-52,-45},{58,-45}},
          color={0,0,127}));
      connect(heaSetAdj, TZonSet.heaSetAdj)
        annotation (Line(points={{-160,-70},{-52,-70},{-52,-49},{58,-49}},
          color={0,0,127}));
      connect(TZonSet.uOccSen, uOccSen)
        annotation (Line(points={{74,-64},{74,-110},{-160,-110}},
          color={255,0,255}));
      connect(TZonSet.uWinSta, uWinSta)
        annotation (Line(points={{86,-64},{86,-120},{-92,-120},{-92,-150},{-160,-150}},
          color={255,0,255}));
      connect(uOcc, opeModSel.uOcc)
        annotation (Line(points={{-160,20.25},{-120,20.25},{-120,9},{-32,9}},
          color={255,0,255}));
      connect(tNexOcc, opeModSel.tNexOcc)
        annotation (Line(points={{-160,140},{-124,140},{-124,7},{-32,7}},
          color={0,0,127}));

      connect(opeModSel.yOpeMod, TZonSet.uOpeMod) annotation (Line(points={{-8,0},{
              22,0},{22,-24},{58,-24}}, color={255,127,0}));
      connect(TSetRooCooOn.y, TZonSet.TZonCooSetOcc) annotation (Line(points={{-78,160},
              {52,160},{52,-29},{58,-29}},      color={0,0,127}));
      connect(TSetRooHeaOn.y, TZonSet.TZonHeaSetOcc) annotation (Line(points={{-78,120},
              {48,120},{48,-37.2},{58,-37.2}},  color={0,0,127}));
      connect(TSetRooHeaOff.y, TZonSet.TZonHeaSetUno) annotation (Line(points={{-78,80},
              {44,80},{44,-41},{58,-41}},     color={0,0,127}));
      connect(TSetRooCooOff.y, TZonSet.TZonCooSetUno) annotation (Line(points={{-78,40},
              {40,40},{40,-33.2},{58,-33.2}}, color={0,0,127}));
      connect(uWinSta, opeModSel.uWinSta[1]) annotation (Line(points={{-160,-150},{
              -92,-150},{-92,-120},{-20,-120},{-20,-12}}, color={255,0,255}));
      connect(cloWin.y, opeModSel.uWinSta[1]) annotation (Line(points={{-78,-90},{
              -20,-90},{-20,-12}},                     color={255,0,255}));
      connect(opeModSel.TZon[1], TZon) annotation (Line(points={{-32,-5},{-128,-5},
              {-128,80.25},{-160,80.25}},color={0,0,127}));
      connect(TZon, optStaHea.TZon) annotation (Line(points={{-160,80.25},{-128,
              80.25},{-128,100},{-62,100}}, color={0,0,127}));
      connect(TSetRooHeaOn.y, optStaHea.TSetZonHea) annotation (Line(points={{-78,
              120},{-72,120},{-72,108},{-62,108}}, color={0,0,127}));
      connect(TSetRooCooOn.y, optStaCoo.TSetZonCoo) annotation (Line(points={{-78,
              160},{-72,160},{-72,130},{-62,130}}, color={0,0,127}));
      connect(TZon, optStaCoo.TZon) annotation (Line(points={{-160,80.25},{-128,
              80.25},{-128,138},{-62,138}}, color={0,0,127}));
      connect(optStaCoo.tOpt, opeModSel.cooDowTim[1]) annotation (Line(points={{-38,
              142},{-34,142},{-34,5},{-32,5}}, color={0,0,127}));
      connect(optStaHea.tOpt, opeModSel.warUpTim[1]) annotation (Line(points={{-38,
              104},{-36,104},{-36,3},{-32,3}}, color={0,0,127}));
    annotation (defaultComponentName="modSetPoi",
      Diagram(coordinateSystem(extent={{-140,-180},{140,180}})),
      Icon(graphics={Text(
            extent={{-100,140},{98,102}},
            textString="%name",
            lineColor={0,0,255}),
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Block that outputs the zone setpoint temperature (<code>TZonCooSet</code>, <code>TZonHeaSet</code>)
and system operation mode (<code>yOpeMod</code>). When operation mode is in freeze
protection setback mode, it also outputs a level 3 freeze protection alarm
<code>yFreProSta</code>. The sequences are implemented according to ASHRAE
Guideline 36, Part 5.B.3 and 5.C.6.
</p>
<p>The sequence consists of the following two subsequences.</p>
<h4>Operation mode selector</h4>
<p>
The subsequence outputs one of seven types of system operation mode (occupied, warmup,
cool-down, setback, freeze protection setback, setup, unoccupied) according
to current time, the time to next occupied hours <code>tNexOcc</code> and
current zone temperature <code>TZon</code>.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode</a>.
</p>
<h4>Zone setpoint temperature reset</h4>
<p>
This sequence is implemented according to Part 5.B.3. It sets the zone temperature setpoint
according to the globally specified setpoints, the local setpoint adjustments, the demand
limits adjustment, the window status and the occupancy status.
See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures</a>.
</p>
<h4>Usage</h4>
<p>
This version is for a single zone only to be used in the Single Zone VAV sequence.
For multizone systems, use
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints</a>.
</p>
</html>",     revisions="<html>
<ul>
<li>
October 24, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
    end ModeAndSetPoints;
  end BaseClasses;
end Examples;
