/* OxidResolver.h generated by WIDL Version 2.2.1 on 06-Dec-01 at 11:54:04 AM */

#include "comBase.h"

#ifndef __INCOxidResolver_h
#define __INCOxidResolver_h


#include "orpc.h"

#ifdef __cplusplus
extern "C" {
#endif

int include_OxidResolver (void);

#ifndef __IOXIDResolver_FWD_DEFINED__
#define __IOXIDResolver_FWD_DEFINED__
typedef interface IOXIDResolver IOXIDResolver;
#endif /* __IOXIDResolver_FWD_DEFINED__ */

#ifndef __ISystemActivator_FWD_DEFINED__
#define __ISystemActivator_FWD_DEFINED__
typedef interface ISystemActivator ISystemActivator;
#endif /* __ISystemActivator_FWD_DEFINED__ */

/* Copyright (c) 2000 Wind River Systems, Inc. */
typedef struct
    {
    COM_VTBL_BEGIN
    COM_VTBL_ENTRY (HRESULT, ResolveOxid, (IOXIDResolver* pThis, OXID* pOxid, unsigned short cRequestedProtseqs, unsigned short* arRequestedProtseqs, DUALSTRINGARRAY** ppdsaOxidBindings, IPID* pipidRemUnknown, DWORD* pAuthnHint));

#define IOXIDResolver_ResolveOxid(pThis, pOxid, cRequestedProtseqs, arRequestedProtseqs, ppdsaOxidBindings, pipidRemUnknown, pAuthnHint) pThis->lpVtbl->ResolveOxid(COM_ADJUST_THIS(pThis), pOxid, cRequestedProtseqs, arRequestedProtseqs, ppdsaOxidBindings, pipidRemUnknown, pAuthnHint)

    COM_VTBL_ENTRY (HRESULT, SimplePing, (IOXIDResolver* pThis, SETID* pSetId));

#define IOXIDResolver_SimplePing(pThis, pSetId) pThis->lpVtbl->SimplePing(COM_ADJUST_THIS(pThis), pSetId)

    COM_VTBL_ENTRY (HRESULT, ComplexPing, (IOXIDResolver* pThis, SETID* pSetId, unsigned short SequenceNum, unsigned short cAddToSet, unsigned short cDelFromSet, OID* AddToSet, OID* DelFromSet, unsigned short* pPingBackoffFactor));

#define IOXIDResolver_ComplexPing(pThis, pSetId, SequenceNum, cAddToSet, cDelFromSet, AddToSet, DelFromSet, pPingBackoffFactor) pThis->lpVtbl->ComplexPing(COM_ADJUST_THIS(pThis), pSetId, SequenceNum, cAddToSet, cDelFromSet, AddToSet, DelFromSet, pPingBackoffFactor)

    COM_VTBL_ENTRY (HRESULT, ServerAlive, (IOXIDResolver* pThis));

#define IOXIDResolver_ServerAlive(pThis) pThis->lpVtbl->ServerAlive(COM_ADJUST_THIS(pThis))

    COM_VTBL_ENTRY (HRESULT, ResolveOxid2, (IOXIDResolver* pThis, OXID* pOxid, unsigned short cRequestedProtseqs, unsigned short* arRequestedProtseqs, DUALSTRINGARRAY** ppdsaOxidBindings, IPID* pipidRemUnknown, DWORD* pAuthnHint, COMVERSION* pComVersion));

#define IOXIDResolver_ResolveOxid2(pThis, pOxid, cRequestedProtseqs, arRequestedProtseqs, ppdsaOxidBindings, pipidRemUnknown, pAuthnHint, pComVersion) pThis->lpVtbl->ResolveOxid2(COM_ADJUST_THIS(pThis), pOxid, cRequestedProtseqs, arRequestedProtseqs, ppdsaOxidBindings, pipidRemUnknown, pAuthnHint, pComVersion)

    COM_VTBL_END
    } IOXIDResolverVtbl;

#ifdef __cplusplus

interface IOXIDResolver {};

HRESULT ResolveOxid (void* pvRpcChannel, OXID* pOxid, unsigned short cRequestedProtseqs, unsigned short* arRequestedProtseqs, DUALSTRINGARRAY** ppdsaOxidBindings, IPID* pipidRemUnknown, DWORD* pAuthnHint);

HRESULT IOXIDResolver_ResolveOxid_vxproxy (void* pvRpcChannel, OXID* pOxid, unsigned short cRequestedProtseqs, unsigned short* arRequestedProtseqs, DUALSTRINGARRAY** ppdsaOxidBindings, IPID* pipidRemUnknown, DWORD* pAuthnHint);

HRESULT SimplePing (void* pvRpcChannel, SETID* pSetId);

HRESULT IOXIDResolver_SimplePing_vxproxy (void* pvRpcChannel, SETID* pSetId);

HRESULT ComplexPing (void* pvRpcChannel, SETID* pSetId, unsigned short SequenceNum, unsigned short cAddToSet, unsigned short cDelFromSet, OID* AddToSet, OID* DelFromSet, unsigned short* pPingBackoffFactor);

HRESULT IOXIDResolver_ComplexPing_vxproxy (void* pvRpcChannel, SETID* pSetId, unsigned short SequenceNum, unsigned short cAddToSet, unsigned short cDelFromSet, OID* AddToSet, OID* DelFromSet, unsigned short* pPingBackoffFactor);

HRESULT ServerAlive (void* pvRpcChannel);

HRESULT IOXIDResolver_ServerAlive_vxproxy (void* pvRpcChannel);

HRESULT ResolveOxid2 (void* pvRpcChannel, OXID* pOxid, unsigned short cRequestedProtseqs, unsigned short* arRequestedProtseqs, DUALSTRINGARRAY** ppdsaOxidBindings, IPID* pipidRemUnknown, DWORD* pAuthnHint, COMVERSION* pComVersion);

HRESULT IOXIDResolver_ResolveOxid2_vxproxy (void* pvRpcChannel, OXID* pOxid, unsigned short cRequestedProtseqs, unsigned short* arRequestedProtseqs, DUALSTRINGARRAY** ppdsaOxidBindings, IPID* pipidRemUnknown, DWORD* pAuthnHint, COMVERSION* pComVersion);

#else

/* C interface definition for IOXIDResolver */

interface IOXIDResolver
    {
    const IOXIDResolverVtbl *  lpVtbl;
    };

#endif /* __cplusplus */

EXTERN_C const IID IID_IOXIDResolver;

typedef struct
    {
    COM_VTBL_BEGIN
    COM_VTBL_ENTRY (HRESULT, ADummyMethod, (ISystemActivator* pThis));

#define ISystemActivator_ADummyMethod(pThis) pThis->lpVtbl->ADummyMethod(COM_ADJUST_THIS(pThis))

    COM_VTBL_END
    } ISystemActivatorVtbl;

#ifdef __cplusplus

interface ISystemActivator {};

HRESULT ADummyMethod (void* pvRpcChannel);

HRESULT ISystemActivator_ADummyMethod_vxproxy (void* pvRpcChannel);

#else

/* C interface definition for ISystemActivator */

interface ISystemActivator
    {
    const ISystemActivatorVtbl *  lpVtbl;
    };

#endif /* __cplusplus */

EXTERN_C const IID IID_ISystemActivator;

#ifdef __cplusplus
}
#endif



#endif /* __INCOxidResolver_h */

