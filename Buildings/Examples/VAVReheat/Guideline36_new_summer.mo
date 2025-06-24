within Buildings.Examples.VAVReheat;
model Guideline36_new_summer
  "Variable air volume flow system with terminal reheat and five thermal zones"
  extends Modelica.Icons.Example;
  extends Buildings.Examples.VAVReheat.BaseClasses.HVACBuilding_new(
    mCor_flow_nominal=ACHCor*VRooCor*conv,
    mSou_flow_nominal=ACHSou*VRooSou*conv,
    mEas_flow_nominal=ACHEas*VRooEas*conv,
    mNor_flow_nominal=ACHNor*VRooNor*conv,
    mWes_flow_nominal=ACHWes*VRooWes*conv,
    redeclare Buildings.Examples.VAVReheat.BaseClasses.Guideline36_new hvac(
        QHeaAHU_flow_nominal=hvac.mHeaAir_flow_nominal*hvac.cpAir*(hvac.THeaAirSup_nominal
           - hvac.THeaAirMix_nominal)*2),
    redeclare Buildings.Examples.VAVReheat.BaseClasses.Floor flo(sampleModel=
          true),
    hHW_CHW_plant(datAll(pla(
          ctl(dpHeaWatRemSet_max={Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max}),
          hp(
            mHeaWatHp_flow_nominal=hHW_CHW_plant.datAll.pla.hp.mChiWatHp_flow_nominal,
            capHeaHp_nominal=hHW_CHW_plant.datAll.pla.hp.capCooHp_nominal,
            mChiWatHp_flow_nominal=0.3*68*6,
            capCooHp_nominal=0.3*2.4e6*6),
          pumHeaWatSec(dp_nominal=fill(Buildings.Templates.Data.Defaults.dpHeaWatLocSet_max,
                hHW_CHW_plant.pumHeaWatSec.nPum)))),
                  ctl(kCtlDpHeaWat=1, TiCtlDpHeaWat=180,
        kCtlDpChiWat=1,
        TiCtlDpChiWat=180)));

  parameter Real ACHCor(final unit="1/h")=6
    "Design air change per hour core";
  parameter Real ACHSou(final unit="1/h")=6
    "Design air change per hour south";
  parameter Real ACHEas(final unit="1/h")=9
    "Design air change per hour east";
  parameter Real ACHNor(final unit="1/h")=6
    "Design air change per hour north";
  parameter Real ACHWes(final unit="1/h")=7
    "Design air change per hour west";
equation
  connect(hHW_CHW_plant.nReqResHeaWat, hvac.nReqResHeaWat) annotation (Line(
        points={{-14,-50},{-14,-42},{54,-42},{54,10.8889},{44.75,10.8889}},
        color={255,127,0}));
  connect(hvac.nReqResChiWat, hHW_CHW_plant.nReqResChiWat) annotation (Line(
        points={{44.75,2.55556},{52,2.55556},{52,-80},{-28,-80},{-28,-56},{-14,
          -56}}, color={255,127,0}));
  connect(hvac.nReqPlaChiWat, hHW_CHW_plant.nReqPlaChiWat) annotation (Line(
        points={{44.75,-8.55556},{56,-8.55556},{56,-82},{-26,-82},{-26,-64},{
          -14,-64}}, color={255,127,0}));
  connect(hvac.nReqPlaHeaWat, hHW_CHW_plant.nReqPlaHeaWat) annotation (Line(
        points={{44.75,-16.8889},{58,-16.8889},{58,-84},{-24,-84},{-24,-70},{
          -14,-70}}, color={255,127,0}));
  connect(weaDat.weaBus, hHW_CHW_plant.weaBus) annotation (Line(
      points={{-70,10},{-58,10},{-58,-42.5},{-40.1,-42.5}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    Documentation(info="<html>
<p>
This model consist of an HVAC system, a building envelope model and a model
for air flow through building leakage and through open doors.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
</p>
<p>
See the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC\">
Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC</a>
for a description of the HVAC system,
and see the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Floor\">
Buildings.Examples.VAVReheat.BaseClasses.Floor</a>
for a description of the building envelope.
</p>
<p>
The control is based on ASHRAE Guideline 36, and implemented
using the sequences from the library
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36\">
Buildings.Controls.OBC.ASHRAE.G36</a> for
multi-zone VAV systems with economizer. The schematic diagram of the HVAC and control
sequence is shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavControlSchematics.png\" border=\"1\"/>
</p>
<p>
A similar model but with a different control sequence can be found in
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>.
Note that this model, because of the frequent time sampling,
has longer computing time than
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>.
The reason is that the time integrator cannot make large steps
because it needs to set a time step each time the control samples
its input.
</p>
</html>", revisions="<html>
<ul>
<li>
May 31, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/Guideline36.mos"
        "Simulate and plot"),
    experiment(
      StartTime=15811200,
      StopTime=15984000,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end Guideline36_new_summer;
