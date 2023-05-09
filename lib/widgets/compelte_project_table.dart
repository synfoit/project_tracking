import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:project_tracking/screen/dashborad.dart';

import '../repository/login_repository.dart';
import '../screen/constants.dart';

class CompletedProjectTable extends StatefulWidget {
  var listdata;
  String listTitle;
  String ssoNumber;
  String token;
  String days;
  CompletedProjectTable(
      {Key? key,
      required this.listdata,
      required this.listTitle,
      required this.ssoNumber,
      required this.token, required this. days})
      : super(key: key);

  @override
  State<CompletedProjectTable> createState() =>
      _CompletedProjectTableState(listdata);
}

class _CompletedProjectTableState extends State<CompletedProjectTable> {
  var listdata;

  var tableRow;

  _CompletedProjectTableState(this.listdata);

  LoginRespository loginResposito = new LoginRespository();

  @override
  void initState() {
    super.initState();
    tableRow = new TableRow(list: listdata);
  }

  //var _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;

  // A Variable to hold the length of table based on the condition of comparing the actual data length with the PaginatedDataTable.defaultRowsPerPage

  int _rowsPerPage1 = PaginatedDataTable.defaultRowsPerPage;
  @override
  Widget build(BuildContext context) {
    print(listdata);
    var tableItemsCount = tableRow.rowCount;

    // PaginatedDataTable.defaultRowsPerPage provides value as 10

    var defaultRowsPerPage = PaginatedDataTable.defaultRowsPerPage;

    // We are checking whether tablesItemCount is less than the defaultRowsPerPage which means we are actually checking the length of the data in DataTableSource with default PaginatedDataTable.defaultRowsPerPage i.e, 10

    var isRowCountLessDefaultRowsPerPage = tableItemsCount < defaultRowsPerPage;

    _rowsPerPage = isRowCountLessDefaultRowsPerPage ? tableItemsCount : defaultRowsPerPage;


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text(widget.listTitle),
            backgroundColor: kPrimaryColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DashBoard(
                            ssoNumber: widget.ssoNumber, token: widget.token)));
              },
            ),
          ),
          body: SafeArea(

            child: PaginatedDataTable(

              rowsPerPage: isRowCountLessDefaultRowsPerPage ? _rowsPerPage : _rowsPerPage1,
           /*   onPageChanged: (int? n) {
                *//*print(n);
                /// value of n is the number of rows displayed so far
                ///
                setState(() {
                  if (n != null) {
                    debugPrint(
                        'onRowsPerPageChanged $_rowsPerPage ${tableRow._rowCount - n}');

                    /// Update rowsPerPage if the remaining count is less than the default rowsPerPage
                    if (tableRow._rowCount - n < _rowsPerPage)
                      _rowsPerPage = tableRow._rowCount - n;

                    /// else, restore default rowsPerPage value
                    else
                      _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
                  } else
                    _rowsPerPage = 0;
                });*//*
              },*/
              columns: <DataColumn>[
                DataColumn(
                  label: Text('SSO Number'),
                ),
                DataColumn(
                  label: Text('Customer Name'),
                ),
                DataColumn(
                  label: Text('Start Date'),
                ),

                DataColumn(
                  label: Text('End Date'),
                ),
                DataColumn(
                  label: Text(widget.days),
                ),
              ],
              source: TableRow(list: listdata),
            ),
          )),
    );
  }
}

class TableRow extends DataTableSource {
  var list;

  TableRow({required this.list});

  @override
  DataRow? getRow(int index) {
    print(list);

    if (index < list.length)
    {
      DateTime dateTime = DateTime.parse(list[index]["startDate"].split("T")[0]);
      // final birthday = DateTime();
      final date2 = DateTime.now();
      final difference;
      String endDate="10/2/2022";

        DateTime enddate = DateTime.parse(list[index]["endDate"].split("T")[0]);
        endDate=list[index]["endDate"].split("T")[0];
        difference = enddate
            .difference(dateTime)
            .inDays;

      return DataRow(cells: [
        DataCell(Text(list[index]["username"])),
        DataCell(Text(list[index]["customerName"])),
        DataCell(Text(list[index]["startDate"].split("T")[0])),
        DataCell(Text(endDate)),
        DataCell(Text("$difference")),
      ]);
    } else {
      //return null;
      return DataRow(cells: [
        DataCell(Text("")),
        DataCell(Text("")),
        DataCell(Text("")),
        DataCell(Text("")),
        DataCell(Text("")),
      ]);
    }
  }

  @override
  bool get isRowCountApproximate => true;

  @override
  int get rowCount => list.length;

  @override
  int get selectedRowCount => 0;
}
