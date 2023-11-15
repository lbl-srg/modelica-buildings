within Buildings.ThermalZones.Detailed;
model ISAT
  "Model of a room in which the air is computed using in situ adaptive tabulation (ISAT)"
  extends Buildings.ThermalZones.Detailed.BaseClasses.PartialCFD(
  redeclare final BaseClasses.ISATAirHeatMassBalance air(
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

  annotation (Icon(graphics={
        Bitmap(extent={{-140,-168},{144,160}}, fileName="modelica://Buildings/Resources/Images/ThermalZones/Detailed/isat.png")}),
Documentation(info="<html>
<p>
Model derived from CFD, in which the air is computed using an adaptive surrogate
model called in situ adaptive tabulation (ISAT).
The isat model can be trained online or in a manner that combines offline
pretraining with online adaptive learning.
</p>
<h4>References</h4>
<p>Wei Tian, Thomas Alonso Sevilla, Dan Li, Wangda Zuo, Michael Wetter. </p>
<p><a href=\"https://www.tandfonline.com/doi/full/10.1080/19401493.2017.1288761\">
Fast and Self-Learning Indoor Airflow Simulation Based on In Situ Adaptive Tabulation.
</a></p>
<p>Journal of Building Performance Simulation, 11(1), pp. 99-112, 2018.</p>
<p>Xu Han, Wei Tian, Wangda Zuo, Michael Wetter, James W. VanGilder.</p>
<p><a href=\"https://www.researchgate.net/profile/Wangda_Zuo/publication/333797408_Optimization_of_Workload_Distribution_of_Data_Centers_Based_on_a_Self-Learning_In_Situ_Adaptive_Tabulation_Model/links/5d0467bf299bf12e7be02981/Optimization-of-Workload-Distribution-of-Data-Centers-Based-on-a-Self-Learning-In-Situ-Adaptive-Tabulation-Model.pdf\">Optimization of Workload Distribution of Data Centers Based on a Self-Learning In Situ Adaptive Tabulation Model. </a></p>
<p>Proc. of the 16th Conference of International Building Performance Simulation
Association (Building Simulation 2019), Italy, September 2-4, Rome, 2019. </p>
</html>",
revisions="<html>
<ul>
<li>April 5, 2020, by Xu Han, Wangda Zuo, Cary Faulkner, Jianjun Hu and Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end ISAT;
