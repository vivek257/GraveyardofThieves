class TeleportGun extends UTWeapon;



DefaultProperties
{

		Begin Object Name=FirstPersonMesh
		SkeletalMesh=SkeletalMesh'WP_LinkGun.Mesh.SK_WP_Linkgun_1P'
		PhysicsAsset=None
		FOV=70
		AnimSets(0)=AnimSet'WP_LinkGun.Anims.K_WP_LinkGun_1P_Base'
	End Object
	AttachmentClass=class'UTAttachment_Linkgun'

	Begin Object Name=PickupMesh
		SkeletalMesh=SkeletalMesh'WP_LinkGun.Mesh.SK_WP_LinkGun_3P'
	End Object
	WeaponProjectiles(0)=class'Guide.Teleport_Projectile' // UTProj_LinkPowerPlasma if linked (see GetProjectileClass() )
	FiringStatesArray(0)=WeaponFiring
	WeaponFireTypes(0)=EWFT_Projectile
	FireInterval(0)=2
	ShotCost(0)=1
	Spread(0)=0
	ShouldFireOnRelease(0)=0
	ShouldFireOnRelease(1)=0
	AmmoCount=10000
	LockerAmmoCount=50
	MaxAmmoCount=10000
	InstantHitDamage(1)=10
	InstantHitDamageTypes(1)=none
}
