const kUpdateRepoOwner = 'hamdosan';
const kUpdateRepoName = 'pencatatan_apk';

bool get isUpdateConfigured =>
    kUpdateRepoOwner.isNotEmpty && kUpdateRepoName.isNotEmpty;
