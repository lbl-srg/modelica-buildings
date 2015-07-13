within Buildings.Rooms.FLEXLAB.Rooms;
package X3B "Models of rooms in test cell X3B"
extends Modelica.Icons.Package;




  annotation(Documentation(info="<html>
  <p>
  This package contains models of rooms in test cell X3B of the FLEXLAB at LBNL. The following image is a drawing
  of test cell X3B. It shows how the different rooms in this example are connected, as well as providing the names
  used in this example for each of the rooms.
  </p>
  <p align=\"center\">
  <img src=\"modelica://Buildings/Resources/Images/Rooms/FLEXLAB/Rooms/X3B.png\"border=\"1\" alt=\"Room locations and names in X3AWithRadiantFloor\"/>
  </p>
  <p>
  There are separate models for each room in test cell X3B. The model for the test cell itself is located in
  <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.X3B.TestCell\">
  Buildings.Rooms.FLEXLAB.Rooms.X3B.TestCell</a>, the model for the connected closet is located at
  <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.X3B.Closet\">
  Buildings.Rooms.FLEXLAB.Rooms.X3B.Closet</a>, and the model for the connected electrical room is located at
  <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.X3B.Electrical\">
  Buildings.Rooms.FLEXLAB.Rooms.X3B.Electrical</a>. Each of the models were developed using construction and
  parameter information taken from architectural drawings. Accurate use of the models will likely require
  combining all three room models to each other.
  </p>
  <p>
  The models in this package are intended to be connected to each other to develop a model of the entirety
  of test cell X3B. Several of the connections are to be made between walls connecting the two spaces to each
  other. Detailed information on the wall in each test cell can be found in the documentation for that test cell.
  The connections between each room in the test cell are described below.
  </p>
  <table border =\"1\" summary = \"Summary of connections between X3B spaces\">
  <tr>
  <th>Physical significance of connection</th>
  <th>Port 1</th>
  <th>Port 2</th>
  </tr>
  <tr>
  <td>Heat transfer through the partition wall between the test cell and the closet</td>
  <td>TestCell.surf_conBou[2]</td>
  <td>Closet.surf_surBou[1]</td>
  </tr>
  <tr>
  <td>Heat transfer through the door in the partition wall between the test cell and the closet</td>
  <td>TestCell.surf_conBou[3]</td>
  <td>Closet.surf_surBou[2]</td>
  </tr>
  <tr>
  <td>Heat transfer through the wall separating the test cell and the electrical room</td>
  <td>TestCell.surf_conBou[4]</td>
  <td>Electrical.surf_surBou[1]</td>
  </tr>
  <tr>
  <td>Heat transfer through the wall separating the closet and the electrical room</td>
  <td>Closet.surf_conBou[1]</td>
  <td>Electrical.surf_surBou[2]</td>
  </tr>
  </table>
  <p>
  An example of how these room models are connected to create full test cell model can be found in
  <a href=\"modelica://Buildings.Rooms.FLEXLAB.Rooms.Examples.X3BWithRadiantFloor\">
  Buildings.Rooms.FLEXLAB.Rooms.Examples.X3AWithRadiantFloor</a>.
  </p>
  </html>"));
end X3B;
