/* tgtinfo.c - xdr routine for coding/decoding a wdbTgtInfo_t */

/* Copyright 1994-1998 Wind River Systems, Inc. */
#include "copyright_wrs.h"

/*
modification history
--------------------
01g,09may01,dtr  Replacing hasFpp and HasAltivec with hasCoprocessor.
01f,06feb01,dtr  Adding altivec probe hasAltivec.
01e,22jan98,c_c  Removed EXT_FUNC references.
01d,30jan96,elp added windll.h, changed xdr_TGT_ADDR_T in macro.
01c,10jun95,pad Included rpc/rpc.h. Fixed history.
01b,04apr95,ms  new data types.
01a,03oct94,ms	generated by rpcgen.
*/

/*
DESCRIPTION
This module contains the eXternal Data Representation (XDR) routine
for the wdbVal_t structure of the WDB protocol.
*/

/* includes */

#include <rpc/rpc.h>

#include "wdbP.h"

/******************************************************************************
*
* xdr_WDB_RT_INFO -
*/ 

BOOL xdr_WDB_RT_INFO
    (
    XDR *		xdrs,
    WDB_RT_INFO *	objp
    )
    {
    if (!xdr_enum (xdrs, (enum_t *)&objp->rtType))
	return (FALSE);

    if (!xdr_WDB_STRING_T (xdrs, &objp->rtVersion))
	return (FALSE);

    if (!xdr_TGT_INT_T (xdrs, &objp->cpuType))
	return (FALSE);

    if (!xdr_UINT32 (xdrs,  &objp->hasCoprocessor))
	return (FALSE);

    if (!xdr_bool (xdrs, &objp->hasWriteProtect))
	return (FALSE);

    if (!xdr_TGT_INT_T (xdrs, &objp->pageSize))
	return (FALSE);

    if (!xdr_TGT_INT_T (xdrs, &objp->endian))
	return (FALSE);

    if (!xdr_WDB_STRING_T (xdrs, &objp->bspName))
	return (FALSE);

    if (!xdr_WDB_STRING_T (xdrs, &objp->bootline))
	return (FALSE);

    if (!xdr_TGT_ADDR_T (xdrs, &objp->memBase))
	return (FALSE);

    if (!xdr_UINT32 (xdrs, &objp->memSize))
	return (FALSE);

    if (!xdr_TGT_INT_T (xdrs, &objp->numRegions))
	return (FALSE);

    if (!xdr_ARRAY (xdrs, (char **)&objp->memRegion, &objp->numRegions,
               objp->numRegions, sizeof (WDB_MEM_REGION), xdr_WDB_MEM_REGION))
            return (FALSE);

    if (!xdr_TGT_ADDR_T (xdrs, &objp->hostPoolBase))
	return (FALSE);

    if (!xdr_UINT32 (xdrs, &objp->hostPoolSize))
	return (FALSE);

    return (TRUE);
    }

/******************************************************************************
*
* xdr_WDB_AGENT_INFO -
*/ 

BOOL xdr_WDB_AGENT_INFO
    (
    XDR *		xdrs,
    WDB_AGENT_INFO *	objp
    )
    {
    if (!xdr_WDB_STRING_T (xdrs, &objp->agentVersion))
	return (FALSE);

    if (!xdr_TGT_INT_T (xdrs, &objp->mtu))
	return (FALSE);

    if (!xdr_TGT_INT_T (xdrs, &objp->mode))
	return (FALSE);

    return (TRUE);
    }

/******************************************************************************
*
* xdr_WDB_TGT_INFO -
*/ 

BOOL xdr_WDB_TGT_INFO
    (
    XDR *		xdrs,
    WDB_TGT_INFO *	objp
    )
    {
    if (!xdr_WDB_AGENT_INFO (xdrs, &objp->agentInfo))
	return (FALSE);

    if (!xdr_WDB_RT_INFO (xdrs, &objp->rtInfo))
	return (FALSE);

    return (TRUE);
    }

