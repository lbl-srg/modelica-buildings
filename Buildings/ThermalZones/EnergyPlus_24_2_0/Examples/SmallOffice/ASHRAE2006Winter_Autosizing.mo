within Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice;
model ASHRAE2006Winter_Autosizing
  "Variable air volume flow system with terminal reheat and five thermal zones using a control sequence published by ASHRAE in 2006, with HVAC sized using autosizing"
  extends Modelica.Icons.Example;
  extends Buildings.Examples.VAVReheat.BaseClasses.HVACBuilding(
    mCor_flow_nominal=flo.cor.sizCoo.QSen_flow/(cpAir*(flo.cor.sizCoo.TSet - hvac.TCooAirSup_nominal)),
    mSou_flow_nominal=flo.sou.sizCoo.QSen_flow/(cpAir*(flo.sou.sizCoo.TSet - hvac.TCooAirSup_nominal)),
    mEas_flow_nominal=flo.eas.sizCoo.QSen_flow/(cpAir*(flo.eas.sizCoo.TSet - hvac.TCooAirSup_nominal)),
    mNor_flow_nominal=flo.nor.sizCoo.QSen_flow/(cpAir*(flo.nor.sizCoo.TSet - hvac.TCooAirSup_nominal)),
    mWes_flow_nominal=flo.wes.sizCoo.QSen_flow/(cpAir*(flo.wes.sizCoo.TSet - hvac.TCooAirSup_nominal)),
    redeclare Buildings.Examples.VAVReheat.BaseClasses.ASHRAE2006 hvac(
      TCooAirSup_nominal=TCooAirSup_nominal,
      VAVBox(
        THeaAirDis_nominal=
          {THeaAirDis_nominal,
           THeaAirDis_nominal,
           THeaAirDis_nominal,
           THeaAirDis_nominal,
           THeaAirDis_nominal}),
      mCooAir_flow_nominal=flo.sysVAV1.sizCoo.QSen_flow/(cpAir*(TZonSetAve - hvac.TCooAirSup_nominal)),
      mHeaVAV_flow_nominal={flo.sou.sizHea.QSen_flow/(cpAir*(hvac.VAVBox[1].THeaAirDis_nominal
           - flo.sou.sizHea.TSet)),flo.eas.sizHea.QSen_flow/(cpAir*(hvac.VAVBox[
          2].THeaAirDis_nominal - flo.eas.sizHea.TSet)),flo.nor.sizHea.QSen_flow
          /(cpAir*(hvac.VAVBox[3].THeaAirDis_nominal - flo.nor.sizHea.TSet)),
          flo.wes.sizHea.QSen_flow/(cpAir*(hvac.VAVBox[4].THeaAirDis_nominal -
          flo.wes.sizHea.TSet)),flo.cor.sizHea.QSen_flow/(cpAir*(hvac.VAVBox[5].THeaAirDis_nominal
           - flo.cor.sizHea.TSet))},
      TCooAirMix_nominal=flo.sysVAV1.sizCoo.TOut,
      wCooAirMix_nominal=flo.sysVAV1.sizCoo.XOut,
      QCooAHU_flow_nominal = 1.3 * hvac.mCooAir_flow_nominal * cpAir *(hvac.TCooAirSup_nominal-hvac.TCooAirMix_nominal),
      Vot_flow_nominal=flo.sysVAV1.sizCoo.mOut_flow/1.2,
      VZonOA_flow_nominal={flo.sou.sizHea.mOut_flow/1.2,flo.eas.sizHea.mOut_flow
          /1.2,flo.nor.sizHea.mOut_flow/1.2,flo.wes.sizHea.mOut_flow/1.2,flo.cor.sizHea.mOut_flow
          /1.2}),
    redeclare Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses.Floor_Autosizing flo);

  parameter Modelica.Units.SI.Temperature
    TZonSetAve = (flo.cor.sizCoo.TSet+flo.sou.sizCoo.TSet+flo.eas.sizCoo.TSet+flo.nor.sizCoo.TSet+flo.wes.sizCoo.TSet)/5
    "Average zone set point temperature to use in AHU airflow sizing";
  parameter Modelica.Units.SI.Temperature
    TCooAirSup_nominal = 12+273.15
    "Nominal discharge air temperature for AHU during cooling";
  parameter Modelica.Units.SI.Temperature
    THeaAirDis_nominal = 40+273.15
    "Nominal discharge air temperature for VAV boxes during heating";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpAir = 1005
    "Specific heat capacity of air";
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_2_0/Examples/SmallOffice/ASHRAE2006Winter_Autosizing.mos" "Simulate and plot"),
    experiment(
      StartTime=432000,
      StopTime=864000,
      Tolerance=1e-07),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}},
        preserveAspectRatio=true)),
    Documentation(
      info="<html>
<p>
Same example as <a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.ASHRAE2006Winter\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.ASHRAE2006Winter</a>,
except that the design cooling air flowrate for each zone and the AHU minimum 
outside air flowrate are determined from the autosizing feature in Spawn.
Note that AHU cooling coil size, and all heating air flowrate and coil sizing 
are determined based on the cooling air flowrate sizing.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 20, 2021, by Michael Wetter:<br/>
Changed parameter declarations for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2829\">issue #2829</a>.
</li>
<li>
October 4, 2021, by Michael Wetter:<br/>
Refactored <a href=\"modelica://Buildings.Examples.VAVReheat\">Buildings.Examples.VAVReheat</a>
and its base classes to separate building from HVAC model.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2652\">issue #2652</a>.
</li>
<li>
September 3, 2021, by Michael Wetter:<br/>
Updated documentation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2600\">issue #2600</a>.
</li>
<li>
November 25, 2019, by Milica Grahovac:<br/>
Impementation of <a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a> model with an EnergyPlus thermal zone instance.
</li>
</ul>
</html>"));
end ASHRAE2006Winter_Autosizing;
