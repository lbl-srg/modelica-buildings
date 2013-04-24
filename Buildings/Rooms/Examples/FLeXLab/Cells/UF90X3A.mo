within Buildings.Rooms.Examples.FLeXLab.Cells;
model UF90X3A "Model of user facility test cell 90X3A"
  extends BaseClasses.GenericTestCell(roo(AFlo=A), sla(
      disPip=disPip,
      length=A/disPip,
      A=A));

  //Geometry declarations
  parameter Modelica.SIunits.Area A = 60.97 "Floor area of the test cell";
  parameter Modelica.SIunits.Length disPip = 0.2 "Distance between the pipes";

end UF90X3A;
